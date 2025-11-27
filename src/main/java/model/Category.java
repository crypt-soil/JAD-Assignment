package model;

import java.util.List;

public class Category {

    private int id;
    private String name;
    private String description;
    private String imageUrl;

    // ⭐ New: store services under this category
    private List<Service> services;

    // ======================
    // Existing fields
    // ======================
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

    // ======================
    // ⭐ New: services
    // ======================
    public List<Service> getServices() { 
        return services; 
    }
    public void setServices(List<Service> services) { 
        this.services = services; 
    }
}
