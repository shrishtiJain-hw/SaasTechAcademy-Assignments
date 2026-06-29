import org.apache.ofbiz.entity.util.EntityQuery
import org.apache.ofbiz.entity.condition.EntityCondition
import org.apache.ofbiz.entity.condition.EntityOperator

String orderId = parameters.orderId ?: context.orderId

if (orderId) {
    // Fetch Header
    def orderHeader = EntityQuery.use(delegator).from("OmsOrderHeader").where("orderId", orderId).queryOne()
    context.orderHeader = orderHeader

    if (orderHeader) {
        // Fetch Parts
        def orderParts = EntityQuery.use(delegator).from("OmsOrderPart").where("orderId", orderId).queryList()
        context.orderParts = orderParts

        // Fetch Items
        def orderItems = EntityQuery.use(delegator).from("OmsOrderItem").where("orderId", orderId).queryList()
        context.orderItems = orderItems

        // Fetch Contact Mechs
        def orderContactMechs = EntityQuery.use(delegator).from("OmsOrderContactMech").where("orderId", orderId).queryList()
        context.orderContactMechs = orderContactMechs

        // Find shipping address
        def shippingContactMech = orderContactMechs.find { it.contactMechPurposeTypeId == "SHIPPING_LOCATION" }
        if (shippingContactMech) {
            def shippingAddress = EntityQuery.use(delegator).from("RmPostalAddress").where("contactMechId", shippingContactMech.contactMechId).queryOne()
            context.shippingAddress = shippingAddress
        }

        // Fetch Payment Preferences
        def orderPaymentPreferences = EntityQuery.use(delegator).from("OmsOrderPaymentPreference").where("orderId", orderId).queryList()
        context.orderPaymentPreferences = orderPaymentPreferences

        // Fetch Adjustments
        def orderAdjustments = EntityQuery.use(delegator).from("OmsOrderAdjustment").where("orderId", orderId).queryList()
        context.orderAdjustments = orderAdjustments

        // Fetch Returns linked to this order
        def returnItems = EntityQuery.use(delegator).from("OmsReturnItem").where("orderId", orderId).queryList()
        context.returnItems = returnItems

        if (returnItems) {
            def returnIds = returnItems.collect { it.returnId }.unique()
            def returnHeaders = EntityQuery.use(delegator).from("OmsReturnHeader").where(EntityCondition.makeCondition("returnId", EntityOperator.IN, returnIds)).queryList()
            context.returnHeaders = returnHeaders
        }

        // Fetch Shipment Sources linked to this order
        def shipmentSources = EntityQuery.use(delegator).from("OmsShipmentItemSource").where("orderId", orderId).queryList()
        context.shipmentSources = shipmentSources

        if (shipmentSources) {
            def shipmentIds = shipmentSources.collect { it.shipmentId }.unique()
            def shipments = EntityQuery.use(delegator).from("OmsShipment").where(EntityCondition.makeCondition("shipmentId", EntityOperator.IN, shipmentIds)).queryList()
            context.shipments = shipments
        }
    }
}
