<style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

    :root {
        --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%);
        --glass-bg: rgba(255, 255, 255, 0.03);
        --glass-border: rgba(255, 255, 255, 0.08);
        --primary-color: #6366f1;
        --primary-hover: #4f46e5;
        --secondary-color: #a855f7;
        --text-main: #f8fafc;
        --text-muted: #94a3b8;
        --success: #10b981;
        --warning: #f59e0b;
        --danger: #ef4444;
        --info: #06b6d4;
    }

    .oms-container {
        font-family: 'Inter', sans-serif;
        color: var(--text-main);
        background: var(--bg-gradient);
        min-height: 100vh;
        padding: 2.5rem;
        box-sizing: border-box;
    }

    .oms-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2.5rem;
    }

    .oms-header h1 {
        font-size: 2.25rem;
        font-weight: 700;
        margin: 0;
        background: linear-gradient(to right, #6366f1, #a855f7);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }

    .glass-card {
        background: var(--glass-bg);
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        border: 1px solid var(--glass-border);
        border-radius: 16px;
        padding: 2rem;
        margin-bottom: 2rem;
        box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
    }

    .search-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 1.5rem;
        margin-bottom: 1.5rem;
    }

    .form-group {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .form-group label {
        font-size: 0.875rem;
        font-weight: 500;
        color: var(--text-muted);
    }

    .form-control {
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid var(--glass-border);
        border-radius: 8px;
        padding: 0.75rem 1rem;
        color: var(--text-main);
        font-size: 0.95rem;
        transition: all 0.3s ease;
        outline: none;
    }

    .form-control:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.2);
        background: rgba(255, 255, 255, 0.08);
    }

    .btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        padding: 0.75rem 1.5rem;
        font-size: 0.95rem;
        font-weight: 600;
        border-radius: 8px;
        border: none;
        cursor: pointer;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        text-decoration: none;
    }

    .btn-primary {
        background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
        color: #fff;
    }

    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 20px -10px rgba(99, 102, 241, 0.5);
    }

    .btn-secondary {
        background: rgba(255, 255, 255, 0.08);
        color: var(--text-main);
        border: 1px solid var(--glass-border);
    }

    .btn-secondary:hover {
        background: rgba(255, 255, 255, 0.15);
    }

    .btn-danger {
        background: var(--danger);
        color: #fff;
    }

    .btn-sm {
        padding: 0.5rem 1rem;
        font-size: 0.85rem;
    }

    .table-container {
        overflow-x: auto;
    }

    .oms-table {
        width: 100%;
        border-collapse: collapse;
        text-align: left;
    }

    .oms-table th {
        padding: 1rem 1.5rem;
        font-size: 0.85rem;
        font-weight: 600;
        text-transform: uppercase;
        color: var(--text-muted);
        border-bottom: 1px solid var(--glass-border);
    }

    .oms-table td {
        padding: 1.25rem 1.5rem;
        font-size: 0.95rem;
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        color: #e2e8f0;
    }

    .oms-table tbody tr {
        transition: background-color 0.3s ease;
    }

    .oms-table tbody tr:hover {
        background-color: rgba(255, 255, 255, 0.02);
    }

    .badge {
        display: inline-flex;
        align-items: center;
        padding: 0.25rem 0.75rem;
        font-size: 0.75rem;
        font-weight: 600;
        border-radius: 9999px;
        text-transform: uppercase;
    }

    .badge-created { background: rgba(59, 130, 246, 0.15); color: #60a5fa; }
    .badge-approved { background: rgba(16, 185, 129, 0.15); color: #34d399; }
    .badge-partial { background: rgba(245, 158, 11, 0.15); color: #fbbf24; }
    .badge-completed { background: rgba(16, 185, 129, 0.25); color: #34d399; }
    .badge-cancelled { background: rgba(239, 68, 68, 0.15); color: #f87171; }
    .badge-paid { background: rgba(6, 182, 212, 0.15); color: #22d3ee; }

    /* Modal Styles */
    .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(15, 23, 42, 0.8);
        backdrop-filter: blur(8px);
        display: none;
        align-items: center;
        justify-content: center;
        z-index: 1000;
        animation: fadeIn 0.3s ease;
    }

    .modal-card {
        background: #1e1e38;
        border: 1px solid var(--glass-border);
        border-radius: 16px;
        width: 100%;
        max-width: 550px;
        padding: 2.5rem;
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.5);
        animation: slideUp 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
    }

    .modal-header h2 {
        margin: 0;
        font-size: 1.5rem;
        font-weight: 700;
    }

    .modal-close {
        background: none;
        border: none;
        color: var(--text-muted);
        font-size: 1.5rem;
        cursor: pointer;
    }

    .modal-actions {
        display: flex;
        justify-content: flex-end;
        gap: 1rem;
        margin-top: 2rem;
    }

    .pagination-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 1.5rem;
        color: var(--text-muted);
    }

    .pagination-buttons {
        display: flex;
        gap: 0.5rem;
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    @keyframes slideUp {
        from { transform: translateY(20px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }
</style>

<div class="oms-container">
    <!-- Header -->
    <div class="oms-header">
        <h1>Order Management System</h1>
        <button class="btn btn-primary" onclick="openCreateModal()">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 5v14M5 12h14"/></svg>
            Create Sales Order
        </button>
    </div>

    <!-- Filter Card -->
    <div class="glass-card">
        <form method="get" action="<@ofbizUrl>findOrder</@ofbizUrl>">
            <div class="search-grid">
                <div class="form-group">
                    <label for="orderId">Order ID</label>
                    <input type="text" id="orderId" name="orderId" class="form-control" placeholder="Search Order ID" value="${parameters.orderId!}"/>
                </div>
                <div class="form-group">
                    <label for="customerName">Customer Name</label>
                    <input type="text" id="customerName" name="customerName" class="form-control" placeholder="Search Customer Name" value="${parameters.customerName!}"/>
                </div>
                <div class="form-group">
                    <label for="fromDate">From Date</label>
                    <input type="date" id="fromDate" name="fromDate" class="form-control" value="${parameters.fromDate!}"/>
                </div>
                <div class="form-group">
                    <label for="thruDate">To Date</label>
                    <input type="date" id="thruDate" name="thruDate" class="form-control" value="${parameters.thruDate!}"/>
                </div>
                <div class="form-group">
                    <label for="statusId">Order Status</label>
                    <select id="statusId" name="statusId" class="form-control">
                        <option value="">-- All Statuses --</option>
                        <option value="ORDER_CREATED" <#if parameters.statusId! == "ORDER_CREATED">selected</#if>>Created</option>
                        <option value="ORDER_APPROVED" <#if parameters.statusId! == "ORDER_APPROVED">selected</#if>>Approved</option>
                        <option value="PARTIALLY_FULFILLED" <#if parameters.statusId! == "PARTIALLY_FULFILLED">selected</#if>>Partially Fulfilled</option>
                        <option value="ORDER_COMPLETED" <#if parameters.statusId! == "ORDER_COMPLETED">selected</#if>>Completed</option>
                        <option value="ORDER_CANCELLED" <#if parameters.statusId! == "ORDER_CANCELLED">selected</#if>>Cancelled</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="paymentStatus">Payment Status</label>
                    <select id="paymentStatus" name="paymentStatus" class="form-control">
                        <option value="">-- All --</option>
                        <option value="PAY_APPROVED" <#if parameters.paymentStatus! == "PAY_APPROVED">selected</#if>>Approved</option>
                        <option value="PAY_AUTHORIZED" <#if parameters.paymentStatus! == "PAY_AUTHORIZED">selected</#if>>Authorized</option>
                        <option value="PAY_DECLINED" <#if parameters.paymentStatus! == "PAY_DECLINED">selected</#if>>Declined</option>
                    </select>
                </div>
            </div>
            <div style="display:flex; justify-content: flex-end; gap: 1rem;">
                <a href="<@ofbizUrl>findOrder</@ofbizUrl>" class="btn btn-secondary">Clear Filters</a>
                <button type="submit" class="btn btn-primary">Search Orders</button>
            </div>
        </form>
    </div>

    <!-- Results Table -->
    <div class="glass-card" style="padding-bottom: 1.5rem;">
        <div class="table-container">
            <table class="oms-table">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Order Date</th>
                        <th>Status</th>
                        <th>Total Amount</th>
                        <th>Payment Status</th>
                        <th>Shipping Address</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <#if orderList?has_content>
                        <#list orderList as order>
                            <tr>
                                <td style="font-weight:600; color:var(--primary-color);">${order.orderId}</td>
                                <td>${order.customerFirstName!} ${order.customerLastName!}</td>
                                <td>${order.orderDate?string("yyyy-MM-dd HH:mm")}</td>
                                <td>
                                    <#assign statusClass = "badge-created"/>
                                    <#if order.statusId! == "ORDER_COMPLETED"><#assign statusClass = "badge-completed"/>
                                    <#elseif order.statusId! == "ORDER_APPROVED"><#assign statusClass = "badge-approved"/>
                                    <#elseif order.statusId! == "ORDER_CANCELLED"><#assign statusClass = "badge-cancelled"/>
                                    <#elseif order.statusId! == "PARTIALLY_FULFILLED"><#assign statusClass = "badge-partial"/>
                                    </#if>
                                    <span class="badge ${statusClass}">${order.statusId?replace("ORDER_", "")}</span>
                                </td>
                                <td style="font-weight:600;">$${order.partTotal!order.orderSubTotal!0.00}</td>
                                <td>
                                    <#if order.paymentStatus?has_content>
                                        <span class="badge badge-paid">${order.paymentStatus?replace("PAY_", "")}</span>
                                    <#else>
                                        <span style="color:var(--text-muted); font-size:0.85rem;">UNPAID</span>
                                    </#if>
                                </td>
                                <td>
                                    <#if order.shippingAddress1?has_content>
                                        ${order.shippingAddress1}, ${order.shippingCity} (${order.shippingPostalCode})
                                    <#else>
                                        <span style="color:var(--text-muted); font-size:0.85rem;">No address</span>
                                    </#if>
                                </td>
                                <td>
                                    <div style="display:flex; gap:0.5rem;">
                                        <button class="btn btn-secondary btn-sm" onclick="openEditModal('${order.orderId}', '${order.statusId}', '${order.contactMechId!}')">
                                            Edit Address
                                        </button>
                                        <a href="<@ofbizUrl>findOrderShipGroups?orderId=${order.orderId}</@ofbizUrl>" class="btn btn-primary btn-sm">
                                            Ship Groups
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr>
                            <td colspan="8" style="text-align: center; color: var(--text-muted); padding: 3rem;">
                                No orders matching the criteria were found.
                            </td>
                        </tr>
                    </#if>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="pagination-bar">
            <span>Showing ${orderList?size} of ${orderListSize!0} orders</span>
            <div class="pagination-buttons">
                <#if (viewIndex > 0)>
                    <a href="<@ofbizUrl>findOrder?viewIndex=${viewIndex - 1}&viewSize=${viewSize}${System.getProperty("line.separator")}</@ofbizUrl>" class="btn btn-secondary btn-sm">Previous</a>
                </#if>
                <#if (orderListSize!0 > (viewIndex + 1) * viewSize)>
                    <a href="<@ofbizUrl>findOrder?viewIndex=${viewIndex + 1}&viewSize=${viewSize}</@ofbizUrl>" class="btn btn-secondary btn-sm">Next</a>
                </#if>
            </div>
        </div>
    </div>
</div>

<!-- Create Order Modal -->
<div id="createModal" class="modal-overlay">
    <div class="modal-card">
        <div class="modal-header">
            <h2>Create New Order</h2>
            <button class="modal-close" onclick="closeCreateModal()">&times;</button>
        </div>
        <form action="<@ofbizUrl>createOrder</@ofbizUrl>" method="post">
            <div style="display:flex; flex-direction:column; gap:1.25rem;">
                <div class="form-group">
                    <label for="customerPartyId">Select Customer</label>
                    <select id="customerPartyId" name="customerPartyId" class="form-control" required>
                        <option value="">-- Choose Customer --</option>
                        <#if customerList?has_content>
                            <#list customerList as cust>
                                <option value="${cust.partyId}">${cust.firstName} ${cust.lastName} (${cust.partyId})</option>
                            </#list>
                        </#if>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Select Product Items</label>
                    <div style="max-height: 120px; overflow-y: auto; background: rgba(0,0,0,0.2); padding: 0.75rem; border-radius: 8px; border:1px solid var(--glass-border); display:flex; flex-direction:column; gap:0.5rem;">
                        <#if productList?has_content>
                            <#list productList as prod>
                                <#if prod.productId != "SALES_TAX">
                                    <label style="display:flex; align-items:center; gap:0.5rem; color:#e2e8f0; font-size:0.9rem; cursor:pointer;">
                                        <input type="checkbox" name="productIdList" value="${prod.productId}" style="accent-color:var(--primary-color);"/>
                                        ${prod.productName}
                                    </label>
                                </#if>
                            </#list>
                        </#if>
                    </div>
                </div>

                <div class="form-group">
                    <label for="quantity">Order Quantity (per selected item)</label>
                    <input type="number" id="quantity" name="productQuantities" class="form-control" value="1" min="1" required/>
                </div>

                <div class="form-group">
                    <label for="postalContactMechId">Shipping Address</label>
                    <select id="postalContactMechId" name="postalContactMechId" class="form-control" required>
                        <option value="">-- Choose Address --</option>
                        <#if postalAddresses?has_content>
                            <#list postalAddresses as addr>
                                <option value="${addr.contactMechId}">${addr.toName!addr.attnName!} - ${addr.address1}, ${addr.city}</option>
                            </#list>
                        </#if>
                    </select>
                </div>

                <div class="search-grid" style="grid-template-columns: 1fr 1fr; margin-bottom: 0;">
                    <div class="form-group">
                        <label for="paymentMethod">Payment Method</label>
                        <select id="paymentMethod" name="paymentMethod" class="form-control" required>
                            <option value="Miscellaneous">Miscellaneous</option>
                            <option value="Credit Card">Credit Card</option>
                            <option value="COD">COD</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="paymentAmount">Payment Amount ($)</label>
                        <input type="number" step="0.01" id="paymentAmount" name="paymentAmount" class="form-control" placeholder="100.00" value="0.00" required/>
                    </div>
                </div>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeCreateModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">Create Order</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Address Modal -->
<div id="editModal" class="modal-overlay">
    <div class="modal-card">
        <div class="modal-header">
            <h2>Edit Shipping Address</h2>
            <button class="modal-close" onclick="closeEditModal()">&times;</button>
        </div>
        <form action="<@ofbizUrl>updateOrderShippingAddress</@ofbizUrl>" method="post">
            <input type="hidden" id="editOrderId" name="orderId"/>
            <div style="display:flex; flex-direction:column; gap:1.25rem;">
                <div class="form-group">
                    <label>Order ID</label>
                    <input type="text" id="editOrderIdDisplay" class="form-control" disabled style="opacity: 0.6;"/>
                </div>
                <div class="form-group">
                    <label for="editPostalContactMechId">Select New Address</label>
                    <select id="editPostalContactMechId" name="postalContactMechId" class="form-control" required>
                        <option value="">-- Choose Address --</option>
                        <#if postalAddresses?has_content>
                            <#list postalAddresses as addr>
                                <option value="${addr.contactMechId}">${addr.toName!addr.attnName!} - ${addr.address1}, ${addr.city}</option>
                            </#list>
                        </#if>
                    </select>
                </div>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeEditModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">Update Address</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openCreateModal() {
        document.getElementById('createModal').style.display = 'flex';
    }

    function closeCreateModal() {
        document.getElementById('createModal').style.display = 'none';
    }

    function openEditModal(orderId, statusId, currentContactMechId) {
        if (statusId === 'ORDER_COMPLETED' || statusId === 'ORDER_CANCELLED' || statusId === 'PARTIALLY_FULFILLED') {
            alert("This order has already been processed or cancelled. Shipping address cannot be modified.");
            return;
        }
        document.getElementById('editOrderId').value = orderId;
        document.getElementById('editOrderIdDisplay').value = orderId;
        document.getElementById('editPostalContactMechId').value = currentContactMechId;
        document.getElementById('editModal').style.display = 'flex';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    window.onclick = function(event) {
        var createModal = document.getElementById('createModal');
        var editModal = document.getElementById('editModal');
        if (event.target == createModal) {
            closeCreateModal();
        }
        if (event.target == editModal) {
            closeEditModal();
        }
    }
</script>
