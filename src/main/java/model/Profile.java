package model;

public class Profile {

    private int customerId;
    private String username;
    private String fullName;
    private String email;
    private String phone;
    private String address;
    private String zipcode;

    public Profile(int customerId, String username, String fullName, String email, String phone, String address, String zipcode) {
        this.customerId = customerId;
        this.username = username;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.zipcode = zipcode;
    }

    public int getCustomerId() { return customerId; }
    public String getUsername() { return username; }
    public String getFullName() { return fullName; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public String getAddress() { return address; }
    public String getZipcode() { return zipcode; }
}
