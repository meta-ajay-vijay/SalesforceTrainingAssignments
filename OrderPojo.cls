public class OrderPojo {
    public Id orderId {get;set;}
    public String customerName {get;set;}
    public String customerEmail {get;set;}
    public Decimal orderTotal {get;set;}
    
    public OrderPojo(){}
    
    public OrderPojo(Id orderId, String customerName, String customerEmail, Decimal orderTotal) {
        this.orderid = orderId;
        this.customerName = customerName;
        this.customerEmail = customerEmail;
        this.orderTotal = orderTotal;
    }
}