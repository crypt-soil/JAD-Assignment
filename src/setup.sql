DROP DATABASE IF EXISTS silvercare;
CREATE DATABASE IF NOT EXISTS silvercare;
USE silvercare;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    zipcode VARCHAR(10)
) ENGINE=InnoDB;

INSERT INTO customers (username, password, full_name, email, phone, address, zipcode)
VALUES (
    'testuser',
    '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',
    'Test User',
    'testuser@example.com',
    '90000000',
    '123 test street',
    '123456'
);

CREATE TABLE service_category (
    cat_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url VARCHAR(255)
) ENGINE=InnoDB;

INSERT INTO service_category (cat_id, name, description, image_url)
VALUES
(1, 'Personal Care', 'Services that support seniors with daily self-care tasks. These include assistance with bathing, grooming, medication reminders, and mobility support to help them stay safe, comfortable, and independent at home.', 'https://justinvillacare.com/wp-content/uploads/2021/10/Dressing-and-Grooming-Caregiver-Services-For-Seniors-Orange-County.jpg'),
(2, 'Home Support', 'Practical help with maintaining a clean, safe, and organised living environment. This covers light housekeeping, meal preparation, laundry, and basic home tasks that reduce physical strain for seniors.', 'https://static.vecteezy.com/system/resources/previews/021/780/287/non_2x/happy-family-walking-together-in-the-garden-old-elderly-using-a-walking-stick-to-help-walk-balance-concept-of-love-and-care-of-the-family-and-health-insurance-for-family-photo.jpg'),
(3, 'Social & Wellness Services', 'Services that enhance emotional well-being and mental engagement. These include companionship visits, social activities, medical escorting, and cognitive exercises designed to prevent loneliness and keep seniors active.', 'https://allsaintsseniorliving.com/wp-content/uploads/2023/04/How-Social-Connections-Keep-Seniors-Healthy-Hero.jpg');

CREATE TABLE service (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image_url VARCHAR(255),
    cat_id INT,
    FOREIGN KEY (cat_id) REFERENCES service_category(cat_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO service (name, description, price, image_url, cat_id)
VALUES
('Bathing & Grooming Assistance', 'Helps seniors stay clean and maintain self-confidence. Caregivers assist with showering, sponging, oral hygiene, and dressing.', 35.00, 'https://tse1.mm.bing.net/th/id/OIP.jBsQL9Bkk7m_w1zw9J03GwHaEq?pid=Api&P=0&h=180', 1),
('Medication Reminder Support', 'Ensures timely and accurate medication intake. Caregivers assist with labeling, preparing pill boxes, and reminders.', 20.00, 'https://www.elderly-homecare.com/wp-content/uploads/2019/08/Nurse-Helping-Senior-Man-To-Organize-Medication.jpg', 1),
('Mobility & Walking Assistance', 'Supports seniors who have difficulty walking or require supervision to move safely around the home.', 30.00, 'https://blog.honestmed.com/wp-content/uploads/2023/08/Blog-Main-Image-Best-Mobility-Aids-Web-Optimized.png', 1),
('Light Housekeeping', 'Basic cleaning tasks including sweeping, mopping, dusting, and keeping living spaces safe and tidy.', 25.00, 'https://fastmaidservice.com/wp-content/uploads/2022/01/Deep-Cleaning-and-Housekeeping-Services.jpg', 2),
('Laundry & Ironing Assistance', 'Caregivers help wash, fold, and iron clothes to support seniors who have difficulty managing laundry on their own.', 22.00, 'https://www.aidby.com/_next/static/media/laundry_image3.520466cc.jpg', 2),
('Meal Preparation', 'Prepares nutritious meals suited to dietary needs. Includes planning, cooking, and cleaning up after meals.', 35.00, 'https://www.bayshore.ca/wp-content/uploads/2018/03/Services-Meal-Prep-1350x850.jpg', 2),
('Companionship Visits', 'Provides emotional support through conversation, games, and social interaction to reduce loneliness.', 40.00, 'https://uploads-ssl.webflow.com/5de31e9059d27b1b2e24e0d8/5e850bd24f3580899765a71c_Senior%20Visit%20in%20home.jpg', 3),
('Outdoor & Medical Escort', 'Caregivers accompany seniors to medical appointments, grocery trips, or casual outdoor walks for safety.', 50.00, 'https://img.freepik.com/premium-photo/senior-woman-walker-nurse-outdoor-park-with-healthcare-elderly-exercise-walking-healthcare-professional-female-person-with-peace-physical-therapy-public-garden-with-carer_590464-279351.jpg?w=2000', 3),
('Cognitive & Memory Activities', 'Engaging activities such as puzzles, memory games, and mental exercises designed to improve cognitive health.', 28.00, 'https://www.setxseniors.com/wp-content/uploads/2014/03/game-night-southeast-texas-senior-citizens-1024x664.jpg', 3);

CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status INT DEFAULT 1,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO bookings (customer_id, booking_date, status) VALUES
(1, NOW() - INTERVAL 2 DAY, 3),
(1, NOW() - INTERVAL 8 DAY, 3),
(1, NOW() - INTERVAL 30 DAY, 3),
(1, NOW() - INTERVAL 150 DAY, 3),
(1, NOW() - INTERVAL 380 DAY, 3);

CREATE TABLE caregiver (
    caregiver_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    years_experience INT DEFAULT 0,
    rating DECIMAL(2,1) DEFAULT 4.5,
    description VARCHAR(255),
    photo_url VARCHAR(255)
) ENGINE=InnoDB;

INSERT INTO caregiver (full_name, gender, years_experience, rating, description, photo_url)
VALUES
('Alice Tan', 'Female', 5, 4.7, 'Experienced in personal hygiene care and mobility support.', 'https://randomuser.me/api/portraits/women/65.jpg'),
('Benjamin Lee', 'Male', 7, 4.9, 'Expert in medication management and senior care.', 'https://randomuser.me/api/portraits/men/32.jpg'),
('Clara Lim', 'Female', 4, 4.6, 'Strong background in dementia care and patient communication.', 'https://randomuser.me/api/portraits/women/44.jpg'),
('David Wong', 'Male', 3, 4.3, 'Friendly caregiver skilled in housekeeping and light chores.', 'https://randomuser.me/api/portraits/men/52.jpg'),
('Evelyn Koh', 'Female', 6, 4.8, 'Specializes in meal prep tailored to dietary needs.', 'https://randomuser.me/api/portraits/women/78.jpg'),
('Farah Noor', 'Female', 8, 4.9, 'Experienced escort caregiver for outings & medical appointments.', 'https://randomuser.me/api/portraits/women/23.jpg');

CREATE TABLE caregiver_user (
    caregiver_user_id INT AUTO_INCREMENT PRIMARY KEY,
    caregiver_id INT NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    FOREIGN KEY (caregiver_id) REFERENCES caregiver(caregiver_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO caregiver_user (caregiver_id, username, password)
VALUES (1, 'cg1', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8');

CREATE TABLE caregiver_service (
    id INT AUTO_INCREMENT PRIMARY KEY,
    caregiver_id INT NOT NULL,
    service_id INT NOT NULL,
    FOREIGN KEY (caregiver_id) REFERENCES caregiver(caregiver_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (service_id) REFERENCES service(service_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO caregiver_service (caregiver_id, service_id) VALUES
(1,1),(1,2),(1,3),
(2,1),(2,3),
(3,1),(3,2),(3,3),
(4,4),(4,5),
(5,4),(5,6),
(1,6),
(6,7),(6,8),
(3,7),
(2,9);

CREATE TABLE booking_details (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    service_id INT,
    caregiver_id INT NULL,
    quantity INT DEFAULT 1,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    subtotal DECIMAL(10,2),
    special_request VARCHAR(255) NULL,
    caregiver_status TINYINT NOT NULL DEFAULT 0,
    check_in_at DATETIME NULL,
    check_out_at DATETIME NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (service_id) REFERENCES service(service_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (caregiver_id) REFERENCES caregiver(caregiver_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO booking_details (booking_id, service_id, caregiver_id, quantity, start_time, end_time, subtotal, special_request)
VALUES
(1, 1, 1, 1, NOW(), NOW() + INTERVAL 1 HOUR, 35.00, 'Wheelchair assistance needed'),
(1, 2, 2, 1, NOW(), NOW() + INTERVAL 1 HOUR, 20.00, NULL),
(2, 6, 5, 1, NOW(), NOW() + INTERVAL 1 HOUR, 35.00, 'Low salt meal preferred'),
(3, 8, 6, 1, NOW(), NOW() + INTERVAL 1 HOUR, 50.00, NULL);

CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    service_id INT,
    remarks VARCHAR(255),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (service_id) REFERENCES service(service_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE admin_user (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

INSERT INTO admin_user (username, email, password)
VALUES ('admin', 'admin@example.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9');

CREATE TABLE cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
);

CREATE TABLE cart_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    service_id INT NOT NULL,
    caregiver_id INT NULL,
    quantity INT DEFAULT 1,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    special_request VARCHAR(255) NULL,
    FOREIGN KEY (cart_id) REFERENCES cart(cart_id)
        ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES service(service_id)
        ON DELETE CASCADE,
    FOREIGN KEY (caregiver_id) REFERENCES caregiver(caregiver_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

DROP PROCEDURE IF EXISTS sp_total_users;
DROP PROCEDURE IF EXISTS sp_popular_service;
DROP FUNCTION IF EXISTS fn_revenue;

DELIMITER $$

CREATE PROCEDURE sp_total_users()
BEGIN
   SELECT COUNT(*) AS total FROM customers;
END $$

CREATE PROCEDURE sp_popular_service()
BEGIN
    SELECT s.name, SUM(bd.quantity) AS total_booked
    FROM booking_details bd
    JOIN service s ON bd.service_id = s.service_id
    GROUP BY s.service_id
    ORDER BY total_booked DESC
    LIMIT 1;
END $$

CREATE FUNCTION fn_revenue(rangeType VARCHAR(10))
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE rev DECIMAL(10,2);

    IF rangeType = 'week' THEN
        SELECT IFNULL(SUM(bd.subtotal), 0)
          INTO rev
        FROM bookings b
        JOIN booking_details bd ON b.booking_id = bd.booking_id
        WHERE YEARWEEK(b.booking_date, 1) = YEARWEEK(CURDATE(), 1);
    ELSEIF rangeType = 'month' THEN
        SELECT IFNULL(SUM(bd.subtotal), 0)
          INTO rev
        FROM bookings b
        JOIN booking_details bd ON b.booking_id = bd.booking_id
        WHERE YEAR(b.booking_date) = YEAR(CURDATE())
          AND MONTH(b.booking_date) = MONTH(CURDATE());
    ELSE
        SELECT IFNULL(SUM(bd.subtotal), 0)
          INTO rev
        FROM bookings b
        JOIN booking_details bd ON b.booking_id = bd.booking_id
        WHERE YEAR(b.booking_date) = YEAR(CURDATE());
    END IF;

    RETURN rev;
END $$

DELIMITER ;
