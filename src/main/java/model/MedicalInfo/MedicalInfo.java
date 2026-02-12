package model.MedicalInfo;

public class MedicalInfo {

	private int medicalId;
	private int customerId;
	private String conditionsCsv;
	private String allergiesText;

	// ✅ Constructor used by DAO
	public MedicalInfo(int medicalId, int customerId, String conditionsCsv, String allergiesText) {
		this.medicalId = medicalId;
		this.customerId = customerId;
		this.conditionsCsv = conditionsCsv;
		this.allergiesText = allergiesText;
	}

	public int getMedicalId() {
		return medicalId;
	}

	public int getCustomerId() {
		return customerId;
	}

	// ===== Medical Conditions =====
	public String getConditionsCsv() {
		return conditionsCsv;
	}

	public void setConditionsCsv(String conditionsCsv) {
		this.conditionsCsv = conditionsCsv;
	}

	// ===== Allergies =====
	public String getAllergiesText() {
		return allergiesText;
	}

	public void setAllergiesText(String allergiesText) {
		this.allergiesText = allergiesText;
	}
}
