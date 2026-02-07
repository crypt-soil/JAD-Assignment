package model;

public class EmergencyContact {
    private int contactId;
    private int customerId;
    private String contactName;
    private String relationship;
    private String phone;
    private String email;

    public EmergencyContact(int contactId, int customerId, String contactName,
                            String relationship, String phone, String email) {
        this.contactId = contactId;
        this.customerId = customerId;
        this.contactName = contactName;
        this.relationship = relationship;
        this.phone = phone;
        this.email = email;
    }

    public int getContactId() { return contactId; }
    public int getCustomerId() { return customerId; }
    public String getContactName() { return contactName; }
    public String getRelationship() { return relationship; }
    public String getPhone() { return phone; }
    public String getEmail() { return email; }
}
