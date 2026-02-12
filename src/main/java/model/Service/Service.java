package model.Service;

/**
 * Represents a single service offered under a category.
 *
 * Each service contains: - Basic info (name, description, image URL) - Pricing
 * - A reference to its category (categoryId) - A UI-related "highlighted" flag
 * used for search results
 *
 * This model is populated and returned by ServiceDAO and used by JSP pages such
 * as service listings and product detail pages.
 */
public class Service {

	/** Unique identifier for the service. */
	private int id;

	/** Name of the service (e.g., "House Cleaning", "Physiotherapy"). */
	private String name;

	/** Description of what the service provides. */
	private String description;

	/** Price of the service. */
	private double price;

	/** URL to the service's display image. */
	private String imageUrl;

	/** Category this service belongs to. */
	private int categoryId;

	/**
	 * Indicates whether this service should be highlighted in the UI (used during
	 * search).
	 */
	private boolean highlighted;

	// ============================================================
	// GETTERS & SETTERS — Core Fields
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

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public int getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}

	// ============================================================
	// GETTERS & SETTERS — Highlight Flag
	// ============================================================
	public boolean isHighlighted() {
		return highlighted;
	}

	public void setHighlighted(boolean highlighted) {
		this.highlighted = highlighted;
	}
}
