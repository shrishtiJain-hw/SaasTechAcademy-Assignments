package org.ordermgmtsystem

import org.apache.ofbiz.entity.GenericValue
import org.apache.ofbiz.entity.condition.EntityCondition
import org.apache.ofbiz.entity.condition.EntityOperator
import org.apache.ofbiz.entity.util.EntityQuery
import org.apache.ofbiz.service.ServiceUtil
import java.sql.Timestamp
import java.math.BigDecimal

/**
 * Search orders using filters, supporting case-insensitive wildcard searches and pagination.
 */
def findOrder() {
    String orderId = context.orderId
    String customerName = context.customerName
    String fromDateStr = context.fromDate
    String thruDateStr = context.thruDate
    String statusId = context.statusId
    String paymentStatus = context.paymentStatus
    String shippingAddress = context.shippingAddress
    Integer viewIndex = context.viewIndex ?: 0
    Integer viewSize = context.viewSize ?: 20

    List conditions = []

    if (orderId) {
        conditions.add(EntityCondition.makeCondition("orderId", EntityOperator.LIKE, "%" + orderId + "%"))
    }
    if (customerName) {
        List nameConds = []
        nameConds.add(EntityCondition.makeCondition("customerFirstName", EntityOperator.LIKE, "%" + customerName + "%"))
        nameConds.add(EntityCondition.makeCondition("customerLastName", EntityOperator.LIKE, "%" + customerName + "%"))
        conditions.add(EntityCondition.makeCondition(nameConds, EntityOperator.OR))
    }
    if (fromDateStr) {
        try {
            Timestamp fromDate = Timestamp.valueOf(fromDateStr.contains(" ") ? fromDateStr : fromDateStr + " 00:00:00.0")
            conditions.add(EntityCondition.makeCondition("orderDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate))
        } catch (Exception e) {
            // ignore parsing errors
        }
    }
    if (thruDateStr) {
        try {
            Timestamp thruDate = Timestamp.valueOf(thruDateStr.contains(" ") ? thruDateStr : thruDateStr + " 23:59:59.9")
            conditions.add(EntityCondition.makeCondition("orderDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate))
        } catch (Exception e) {
            // ignore parsing errors
        }
    }
    if (statusId) {
        conditions.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, statusId))
    }
    if (paymentStatus) {
        conditions.add(EntityCondition.makeCondition("paymentStatus", EntityOperator.EQUALS, paymentStatus))
    }
    if (shippingAddress) {
        List addrConds = []
        addrConds.add(EntityCondition.makeCondition("shippingAddress1", EntityOperator.LIKE, "%" + shippingAddress + "%"))
        addrConds.add(EntityCondition.makeCondition("shippingCity", EntityOperator.LIKE, "%" + shippingAddress + "%"))
        addrConds.add(EntityCondition.makeCondition("shippingPostalCode", EntityOperator.LIKE, "%" + shippingAddress + "%"))
        conditions.add(EntityCondition.makeCondition(addrConds, EntityOperator.OR))
    }

    EntityCondition mainCond = conditions ? EntityCondition.makeCondition(conditions, EntityOperator.AND) : null

    def countQuery = EntityQuery.use(delegator).from("FindOrderView")
    if (mainCond) {
        countQuery = countQuery.where(mainCond)
    }
    long count = countQuery.queryCount()

    int startRow = viewIndex * viewSize + 1
    def listQuery = EntityQuery.use(delegator)
        .from("FindOrderView")
        .orderBy("-orderDate")
        .cursorScrollSensitive()
    if (mainCond) {
        listQuery = listQuery.where(mainCond)
    }
    def iterator = listQuery.queryIterator()
    List orderList = iterator.getPartialList(startRow, viewSize)
    iterator.close()

    Map result = success()
    result.orderList = orderList
    result.orderListSize = (int) count
    result.viewIndex = viewIndex
    result.viewSize = viewSize
    return result
}

/**
 * Create a new custom order in OmsOrderHeader, OmsOrderPart, and OmsOrderItem tables.
 */
def createOrder() {
    String customerPartyId = context.customerPartyId
    def rawProductIdList = context.productIdList
    def rawProductQuantities = context.productQuantities

    List productIdList = []
    if (rawProductIdList instanceof List) {
        productIdList = rawProductIdList
    } else if (rawProductIdList instanceof String) {
        productIdList = [rawProductIdList]
    }

    List productQuantities = []
    if (rawProductQuantities instanceof List) {
        productQuantities = rawProductQuantities
    } else if (rawProductQuantities instanceof String || rawProductQuantities instanceof Number) {
        productQuantities = [rawProductQuantities]
    }

    String postalContactMechId = context.postalContactMechId
    String paymentMethod = context.paymentMethod
    BigDecimal paymentAmount = context.paymentAmount
    String orderSource = context.orderSource ?: "WEB"

    if (productIdList.isEmpty() || productQuantities.isEmpty() || productIdList.size() != productQuantities.size()) {
        return error("Product items and quantities are mismatched or missing.")
    }

    // Validate Customer exists
    GenericValue customer = EntityQuery.use(delegator).from("RmParty").where("partyId", customerPartyId).queryOne()
    if (!customer) {
        return error("Customer Party ID: " + customerPartyId + " does not exist.")
    }

    // Validate Contact Mech exists
    GenericValue contactMech = EntityQuery.use(delegator).from("RmContactMech").where("contactMechId", postalContactMechId).queryOne()
    if (!contactMech) {
        return error("Shipping Postal Address Contact Mech ID: " + postalContactMechId + " does not exist.")
    }

    String orderId = delegator.getNextSeqId("OmsOrderHeader")
    Timestamp now = new Timestamp(System.currentTimeMillis())

    BigDecimal subTotal = BigDecimal.ZERO
    List itemsToCreate = []

    // Create Order Items and compute subtotal
    for (int i = 0; i < productIdList.size(); i++) {
        String productId = productIdList[i]
        Object qtyObj = productQuantities[i]
        BigDecimal quantity = new BigDecimal(qtyObj.toString())

        // Check product exists
        GenericValue product = EntityQuery.use(delegator).from("PimProduct").where("productId", productId).queryOne()
        if (!product) {
            return error("Product ID: " + productId + " does not exist.")
        }

        // Fetch price
        BigDecimal unitPrice = new BigDecimal("100.00") // default fallback
        GenericValue priceVal = EntityQuery.use(delegator)
            .from("PimProductPrice")
            .where("productId", productId, "productPriceTypeId", "LIST_PRICE")
            .queryFirst()
        if (priceVal && priceVal.price) {
            unitPrice = priceVal.price
        }

        subTotal = subTotal.add(unitPrice.multiply(quantity))

        // Create Item Value (persist later)
        GenericValue item = delegator.makeValue("OmsOrderItem")
        item.orderId = orderId
        item.orderPartSeqId = "00001"
        item.orderItemSeqId = String.format("%05d", i + 1)
        item.productId = productId
        item.quantity = quantity
        item.unitPrice = unitPrice
        item.itemStatus = "ORDER_CREATED"
        item.externalId = orderId + "-" + (i + 1)
        item.returnsEligibility = "ELIGIBLE"
        itemsToCreate.add(item)
    }

    BigDecimal taxRate = new BigDecimal("0.05") // 5% tax
    BigDecimal taxSubTotal = subTotal.multiply(taxRate).setScale(2, BigDecimal.ROUND_HALF_UP)
    BigDecimal total = subTotal.add(taxSubTotal)

    // Create Order Header
    GenericValue header = delegator.makeValue("OmsOrderHeader")
    header.orderId = orderId
    header.statusId = "ORDER_CREATED"
    header.orderDate = now
    header.orderSource = orderSource
    header.orderType = "SALES_ORDER"
    header.orderSubTotal = subTotal
    header.taxSubTotal = taxSubTotal
    header.discount = BigDecimal.ZERO
    header.currency = "USD"
    header.canReturn = "TRUE"
    header.displayOrderId = orderId
    header.storeId = "STORE_001"
    header.email = customerPartyId.contains("@") ? customerPartyId : "customer@example.com"
    header.create()

    // Create Order Part (Ship Group)
    GenericValue part = delegator.makeValue("OmsOrderPart")
    part.orderId = orderId
    part.orderPartSeqId = "00001"
    part.customerPartyId = customerPartyId
    part.postalContactMechId = postalContactMechId
    part.statusId = "PART_CREATED"
    part.partTotal = total
    part.shipmentMethodEnumId = "GROUND"
    part.create()

    // Persist Order Items now that OmsOrderPart exists
    for (GenericValue item : itemsToCreate) {
        item.create()
    }

    // Create Order Contact Mech
    GenericValue orderMech = delegator.makeValue("OmsOrderContactMech")
    orderMech.orderId = orderId
    orderMech.contactMechPurposeTypeId = "SHIPPING_LOCATION"
    orderMech.contactMechId = postalContactMechId
    orderMech.create()

    // Create Payment Preference (Tender)
    GenericValue paymentPref = delegator.makeValue("OmsOrderPaymentPreference")
    paymentPref.orderPaymentPreferenceId = delegator.getNextSeqId("OmsOrderPaymentPreference")
    paymentPref.orderId = orderId
    paymentPref.orderPartSeqId = "00001"
    paymentPref.paymentMethod = paymentMethod
    paymentPref.amountAuthorized = total
    paymentPref.transactionId = "TX-" + System.currentTimeMillis()
    paymentPref.paymentStatus = "PAY_AUTHORIZED"
    paymentPref.paymentDevice = "NoReader"
    paymentPref.paymentSequenceNumber = "1"
    paymentPref.create()

    Map result = success()
    result.orderId = orderId
    return result
}

/**
 * Update the shipping address of an order if it has not yet been shipped.
 */
def updateOrderShippingAddress() {
    String orderId = context.orderId
    String postalContactMechId = context.postalContactMechId

    GenericValue header = EntityQuery.use(delegator).from("OmsOrderHeader").where("orderId", orderId).queryOne()
    if (!header) {
        return error("Order ID: " + orderId + " does not exist.")
    }

    // Verify order hasn't shipped/completed
    if (header.statusId == "ORDER_COMPLETED" || header.statusId == "ORDER_CANCELLED" || header.statusId == "PARTIALLY_FULFILLED") {
        return error("Cannot update shipping address: Order is already in status " + header.statusId)
    }

    // Validate new Address exists
    GenericValue contactMech = EntityQuery.use(delegator).from("RmContactMech").where("contactMechId", postalContactMechId).queryOne()
    if (!contactMech) {
        return error("Shipping Address Contact Mech ID: " + postalContactMechId + " does not exist.")
    }

    // Update OmsOrderContactMech (SHIPPING_LOCATION)
    GenericValue orderMech = EntityQuery.use(delegator)
        .from("OmsOrderContactMech")
        .where("orderId", orderId, "contactMechPurposeTypeId", "SHIPPING_LOCATION")
        .queryOne()

    if (orderMech) {
        orderMech.remove()
    }
    
    orderMech = delegator.makeValue("OmsOrderContactMech")
    orderMech.orderId = orderId
    orderMech.contactMechPurposeTypeId = "SHIPPING_LOCATION"
    orderMech.contactMechId = postalContactMechId
    orderMech.create()

    // Update OmsOrderPart records
    List parts = EntityQuery.use(delegator).from("OmsOrderPart").where("orderId", orderId).queryList()
    for (GenericValue part : parts) {
        part.postalContactMechId = postalContactMechId
        part.store()
    }

    return success("Order shipping address successfully updated.")
}

/**
 * Create or configure a shipping group/part shipment method and estimated delivery date.
 */
def createOrderItemShipGroup() {
    String orderId = context.orderId
    String shipmentMethodEnumId = context.shipmentMethodEnumId
    String estimatedDeliveryDateStr = context.estimatedDeliveryDate

    List parts = EntityQuery.use(delegator).from("OmsOrderPart").where("orderId", orderId).queryList()
    if (!parts) {
        return error("No order parts found for Order ID: " + orderId)
    }

    Timestamp deliveryDate = null
    if (estimatedDeliveryDateStr) {
        try {
            deliveryDate = Timestamp.valueOf(estimatedDeliveryDateStr.contains(" ") ? estimatedDeliveryDateStr : estimatedDeliveryDateStr + " 18:00:00.0")
        } catch (Exception e) {
            // ignore parsing issues
        }
    }

    // Configure the first part (or all parts)
    for (GenericValue part : parts) {
        part.shipmentMethodEnumId = shipmentMethodEnumId
        if (deliveryDate) {
            part.estimatedDeliveryDate = deliveryDate
        }
        part.store()
    }

    return success("Ship group details successfully updated.")
}
