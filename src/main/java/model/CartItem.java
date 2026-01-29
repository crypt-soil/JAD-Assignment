package model;

import java.sql.Timestamp;

/*
 * Lois Poh 
 * 2429478
 */
public class CartItem {
    private int itemId;
    private int serviceId;
    private String serviceName;
    private double price;
    private int quantity;
    private Timestamp startTime;
    private Timestamp endTime;
    private Integer caregiverId; // nullable
    private String specialRequest; // nullable

    public CartItem(int itemId, int serviceId, String serviceName, double price, int quantity,
                    Timestamp startTime, Timestamp endTime, Integer caregiverId, String specialRequest) {
        this.itemId = itemId;
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.price = price;
        this.quantity = quantity;
        this.startTime = startTime;
        this.endTime = endTime;
        this.caregiverId = caregiverId;
        this.specialRequest = specialRequest;
    }

    public int getItemId() { return itemId; }
    public int getServiceId() { return serviceId; }
    public String getServiceName() { return serviceName; }
    public double getPrice() { return price; }
    public int getQuantity() { return quantity; }
    public Timestamp getStartTime() { return startTime; }
    public Timestamp getEndTime() { return endTime; }
    public Integer getCaregiverId() { return caregiverId; }
    public String getSpecialRequest() { return specialRequest; }

    public double getLineTotal() { return price * quantity; }
}
