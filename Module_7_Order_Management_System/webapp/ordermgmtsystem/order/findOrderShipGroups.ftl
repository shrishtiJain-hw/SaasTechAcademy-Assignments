<style>
    .ship-card {
        background: rgba(255, 255, 255, 0.02);
        border: 1px solid rgba(255, 255, 255, 0.05);
        border-radius: 12px;
        padding: 1.5rem;
        margin-top: 1.5rem;
    }

    .detail-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .detail-item {
        display: flex;
        flex-direction: column;
        gap: 0.25rem;
    }

    .detail-item .label {
        font-size: 0.8rem;
        color: var(--text-muted);
        text-transform: uppercase;
        font-weight: 600;
    }

    .detail-item .value {
        font-size: 1.05rem;
        font-weight: 500;
        color: var(--text-main);
    }
</style>

<div class="oms-container-sub" style="padding-top: 0;">
    <!-- Search Order Ship Groups Header Card -->
    <div class="glass-card-sub" style="margin-bottom: 2rem;">
        <h3 style="margin-top: 0; margin-bottom: 1.5rem; font-weight: 600; font-size: 1.25rem;">Search Ship Groups by Order</h3>
        <form action="<@ofbizUrl>findOrderShipGroups</@ofbizUrl>" method="get">
            <div style="display:flex; gap: 1rem; align-items: flex-end; max-width: 500px;">
                <div class="form-group-sub" style="flex: 1;">
                    <label for="searchOrderId">Enter Order ID</label>
                    <input type="text" id="searchOrderId" name="orderId" class="form-control-sub" placeholder="e.g. ORD789" value="${parameters.orderId!}" required/>
                </div>
                <button type="submit" class="btn-sub btn-primary-sub">Search Ship Groups</button>
            </div>
        </form>
    </div>

    <#if parameters.orderId?has_content>
        <#if orderHeader?has_content>
            <!-- General Order Info -->
            <div class="glass-card-sub">
                <div style="display:flex; justify-content:space-between; align-items:center; border-bottom: 1px solid var(--glass-border); padding-bottom: 1rem; margin-bottom: 1.5rem;">
                    <h3 style="margin: 0; font-weight: 600; font-size: 1.25rem;">Order Details: ${orderHeader.orderId}</h3>
                    <span class="badge badge-created" style="padding: 0.35rem 1rem;">${orderHeader.statusId}</span>
                </div>

                <div class="detail-grid">
                    <div class="detail-item">
                        <span class="label">Order Date</span>
                        <span class="value">${orderHeader.orderDate?string("yyyy-MM-dd HH:mm")}</span>
                    </div>
                    <div class="detail-item">
                        <span class="label">Order Type</span>
                        <span class="value">${orderHeader.orderType!}</span>
                    </div>
                    <div class="detail-item">
                        <span class="label">Order Subtotal</span>
                        <span class="value">$${orderHeader.orderSubTotal!0.00}</span>
                    </div>
                    <div class="detail-item">
                        <span class="label">Tax Amount</span>
                        <span class="value">$${orderHeader.taxSubTotal!0.00}</span>
                    </div>
                    <div class="detail-item">
                        <span class="label">Shipping Address</span>
                        <span class="value">
                            <#if shippingAddress?has_content>
                                ${shippingAddress.address1!}, ${shippingAddress.city!} (${shippingAddress.postalCode!})
                            <#else>
                                <span style="color:var(--text-muted);">None</span>
                            </#if>
                        </span>
                    </div>
                </div>

                <!-- Ship Groups / Parts Table -->
                <h4 style="margin-top: 2rem; margin-bottom: 1rem; font-weight: 600;">Associated Ship Groups (Order Parts)</h4>
                <div class="table-container">
                    <table class="oms-table">
                        <thead>
                            <tr>
                                <th>Part Seq ID</th>
                                <th>Customer / Vendor</th>
                                <th>Shipping Method</th>
                                <th>Estimated Delivery</th>
                                <th>Part Total</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#if orderParts?has_content>
                                <#list orderParts as part>
                                    <tr>
                                        <td style="font-weight: 600; color: var(--primary-color);">${part.orderPartSeqId}</td>
                                        <td>${part.customerPartyId!part.vendorPartyId!}</td>
                                        <td style="font-weight: 500;">${part.shipmentMethodEnumId!"-"}</td>
                                        <td>${(part.estimatedDeliveryDate?string("yyyy-MM-dd"))!"-"}</td>
                                        <td style="font-weight: 600;">$${part.partTotal!0.00}</td>
                                        <td><span class="badge badge-approved">${part.statusId!}</span></td>
                                    </tr>
                                </#list>
                            <#else>
                                <tr>
                                    <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 1.5rem;">
                                        No ship groups exist for this order.
                                    </td>
                                </tr>
                            </#if>
                        </tbody>
                    </table>
                </div>

                <!-- Order Items Table -->
                <h4 style="margin-top: 2.5rem; margin-bottom: 1rem; font-weight: 600;">Ordered Items</h4>
                <div class="table-container">
                    <table class="oms-table">
                        <thead>
                            <tr>
                                <th>Item Seq</th>
                                <th>Part Seq</th>
                                <th>Product ID</th>
                                <th>Quantity</th>
                                <th>Unit Price</th>
                                <th>Total</th>
                                <th>Fulfillment Type</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#if orderItems?has_content>
                                <#list orderItems as item>
                                    <tr>
                                        <td>${item.orderItemSeqId}</td>
                                        <td>${item.orderPartSeqId}</td>
                                        <td style="font-weight: 600; color: var(--secondary-color);">${item.productId}</td>
                                        <td>${item.quantity}</td>
                                        <td>$${item.unitPrice}</td>
                                        <td style="font-weight: 600;">$${(item.quantity * item.unitPrice)?string("0.00")}</td>
                                        <td>${item.fulfillmentType!"-"}</td>
                                        <td><span class="badge badge-created">${item.itemStatus!}</span></td>
                                    </tr>
                                </#list>
                            <#else>
                                <tr>
                                    <td colspan="8" style="text-align: center; color: var(--text-muted); padding: 1.5rem;">
                                        No items exist in this order.
                                    </td>
                                </tr>
                            </#if>
                        </tbody>
                    </table>
                </div>

                <!-- Linked Shipments Details -->
                <#if shipments?has_content>
                    <h4 style="margin-top: 2.5rem; margin-bottom: 1rem; font-weight: 600;">Fulfillment Shipments</h4>
                    <#list shipments as ship>
                        <div class="ship-card">
                            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem; border-bottom:1px dashed rgba(255,255,255,0.08); padding-bottom:0.5rem;">
                                <span style="font-weight:600; color:var(--primary-color);">Shipment ID: ${ship.shipmentId}</span>
                                <span class="badge badge-paid">${ship.statusId!}</span>
                            </div>
                            <div class="detail-grid" style="margin-bottom:0; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem;">
                                <div class="detail-item">
                                    <span class="label">Ship Date (Est)</span>
                                    <span class="value">${(ship.estimatedShipDate?string("yyyy-MM-dd"))!"-"}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="label">Est Cost</span>
                                    <span class="value">$${ship.estimatedShipCost!0.00} ${ship.costUomId!}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="label">Bin Location</span>
                                    <span class="value">${ship.binLocationNumber!"-"}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="label">Type</span>
                                    <span class="value">${ship.shipmentTypeEnumId!}</span>
                                </div>
                            </div>
                        </div>
                    </#list>
                </#if>
            </div>
        <#else>
            <div class="glass-card-sub" style="text-align: center; color: var(--text-muted); padding: 3rem;">
                Order ID "${parameters.orderId}" was not found. Please verify the ID and try again.
            </div>
        </#if>
    <#else>
        <div class="glass-card-sub" style="text-align: center; color: var(--text-muted); padding: 3rem;">
            Please enter an Order ID above to manage ship groups and view fulfillment status.
        </div>
    </#if>
</div>
