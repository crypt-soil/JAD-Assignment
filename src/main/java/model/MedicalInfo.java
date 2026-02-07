package model;

public class MedicalInfo {
    private int medicalId;
    private int customerId;
    private String medicalInfo;

    public MedicalInfo(int medicalId, int customerId, String medicalInfo) {
        this.medicalId = medicalId;
        this.customerId = customerId;
        this.medicalInfo = medicalInfo;
    }

    public int getMedicalId() { return medicalId; }
    public int getCustomerId() { return customerId; }
    public String getMedicalInfo() { return medicalInfo; }

    public void setMedicalInfo(String medicalInfo) { this.medicalInfo = medicalInfo; }
}
