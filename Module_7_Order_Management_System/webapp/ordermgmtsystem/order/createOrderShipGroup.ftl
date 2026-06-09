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
    }

    .oms-container-sub {
        font-family: 'Inter', sans-serif;
        color: var(--text-main);
        padding: 0 0 1.5rem 0;
        box-sizing: border-box;
    }

    .glass-card-sub {
        background: var(--glass-bg);
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        border: 1px solid var(--glass-border);
        border-radius: 16px;
        padding: 2rem;
        margin-bottom: 2rem;
        box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
    }

    .grid-three {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        align-items: flex-end;
    }

    .form-group-sub {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .form-group-sub label {
        font-size: 0.875rem;
        font-weight: 500;
        color: var(--text-muted);
    }

    .form-control-sub {
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid var(--glass-border);
        border-radius: 8px;
        padding: 0.75rem 1rem;
        color: var(--text-main);
        font-size: 0.95rem;
        transition: all 0.3s ease;
        outline: none;
    }

    .form-control-sub:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.2);
        background: rgba(255, 255, 255, 0.08);
    }

    .btn-sub {
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

    .btn-primary-sub {
        background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
        color: #fff;
    }

    .btn-primary-sub:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 20px -10px rgba(99, 102, 241, 0.5);
    }
</style>

<div class="oms-container-sub">
    <div style="margin-bottom: 2rem;">
        <h1 style="font-size: 2.25rem; font-weight: 700; margin: 0; background: linear-gradient(to right, #6366f1, #a855f7); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Order Ship Group Management</h1>
    </div>

    <!-- Create Ship Group Form Card -->
    <div class="glass-card-sub">
        <h3 style="margin-top: 0; margin-bottom: 1.5rem; font-weight: 600; font-size: 1.25rem;">Create / Configure Ship Group</h3>
        <form action="<@ofbizUrl>createOrderItemShipGroup</@ofbizUrl>" method="post">
            <div class="grid-three">
                <div class="form-group-sub">
                    <label for="orderId">Order ID</label>
                    <input type="text" id="orderId" name="orderId" class="form-control-sub" placeholder="e.g. ORD789" value="${parameters.orderId!}" required/>
                </div>
                <div class="form-group-sub">
                    <label for="shipmentMethodEnumId">Shipping Method</label>
                    <select id="shipmentMethodEnumId" name="shipmentMethodEnumId" class="form-control-sub" required>
                        <option value="GROUND">UPS Ground</option>
                        <option value="2ND_DAY">UPS 2nd Day</option>
                        <option value="FEDEX_GROUND">FedEx Ground</option>
                        <option value="DHL_EXPRESS">DHL Express</option>
                        <option value="COD">COD</option>
                    </select>
                </div>
                <div class="form-group-sub">
                    <label for="estimatedDeliveryDate">Estimated Delivery Date</label>
                    <input type="date" id="estimatedDeliveryDate" name="estimatedDeliveryDate" class="form-control-sub"/>
                </div>
                <div>
                    <button type="submit" class="btn-sub btn-primary-sub" style="width: 100%;">Configure Ship Group</button>
                </div>
            </div>
        </form>
    </div>
</div>
