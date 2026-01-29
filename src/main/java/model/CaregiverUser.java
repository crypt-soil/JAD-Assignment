package model;

public class CaregiverUser {
    private int caregiverUserId;
    private int caregiverId;
    private String username;

    public int getCaregiverUserId() {
        return caregiverUserId;
    }

    public void setCaregiverUserId(int caregiverUserId) {
        this.caregiverUserId = caregiverUserId;
    }

    public int getCaregiverId() {
        return caregiverId;
    }

    public void setCaregiverId(int caregiverId) {
        this.caregiverId = caregiverId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
