package model;

public class Caregiver {
    private int caregiverId;
    private String fullName;
    private String gender;
    private int yearsExperience;
    private double rating;
    private String description;
    private String photoUrl;

    public Caregiver() {}

    public int getCaregiverId() { return caregiverId; }
    public void setCaregiverId(int caregiverId) { this.caregiverId = caregiverId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public int getYearsExperience() { return yearsExperience; }
    public void setYearsExperience(int yearsExperience) { this.yearsExperience = yearsExperience; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getPhotoUrl() { return photoUrl; }
    public void setPhotoUrl(String photoUrl) { this.photoUrl = photoUrl; }
}
