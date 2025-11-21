package model;

public class BookingItem {
	private String serviceName;
    private int quantity;
    private double subtotal;

    public BookingItem(String serviceName, int quantity, double subtotal) {
        this.serviceName = serviceName;
        this.quantity = quantity;
        this.subtotal = subtotal;
    }

    public String getServiceName() {
        return serviceName;
    }

    public int getQuantity() {
        return quantity;
    }

    public double getSubtotal() {
        return subtotal;
    }
}
