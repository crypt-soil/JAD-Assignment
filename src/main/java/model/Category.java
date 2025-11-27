package model;

import java.util.List;

/**
 * Represents a service category in the system.
 * 
 * Each category contains: - Basic info (name, description, image URL) - A list
 * of Service objects belonging to this category
 *
 * This model is used by both DAO classes and JSP pages to render category
 * information and its related services.
 */
public class Category {

	/** Unique identifier for the category. */
	private int id;

	/** Category display name (e.g., "Home Support", "Personal Care"). */
	private String name;

	/** Brief description explaining what this category offers. */
	private String description;

	/** URL to the category's display image. */
	private String imageUrl;

	/**
	 * List of services under this category.
	 * 
	 * This is populated when using: - getCategoryWithServices(id) - or manually by
	 * various servlets/controllers.
	 */
	private List<Service> services;

	// ============================================================
	// GETTERS & SETTERS — Basic Fields
	// ============================================================

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	// ============================================================
	// GETTERS & SETTERS — Services
	// ============================================================

	public List<Service> getServices() {
		return services;
	}

	public void setServices(List<Service> services) {
		this.services = services;
	}
}
