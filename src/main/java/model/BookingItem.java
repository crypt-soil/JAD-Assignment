package model;

public class BookingItem {
    private String serviceName;
    private int quantity;
    private double subtotal;
    private int caregiverStatus;
    private String caregiverName;
    private String caregiverContact;

    public BookingItem(String serviceName, int quantity, double subtotal, int caregiverStatus,
                       String caregiverName, String caregiverContact) {
        this.serviceName = serviceName;
        this.quantity = quantity;
        this.subtotal = subtotal;
        this.caregiverStatus = caregiverStatus;
        this.caregiverName = caregiverName;
        this.caregiverContact = caregiverContact;
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

    public int getCaregiverStatus() {
        return caregiverStatus;
    }

    public String getCaregiverName() {
        return caregiverName;
    }

    public String getCaregiverContact() {
        return caregiverContact;
    }
}
