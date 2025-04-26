--Group Work
-- Create database
CREATE DATABASE ecommerce;
USE ecommerce;

-- Brand table
CREATE TABLE brand (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Product category table (with self-referencing for hierarchy)
CREATE TABLE product_category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES product_category(id)
);

-- Size category table
CREATE TABLE size_category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Size options table
CREATE TABLE size_option (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(20) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES size_category(id)
);

-- Color table
CREATE TABLE color (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    hex_code VARCHAR(7) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Attribute category table
CREATE TABLE attribute_category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Attribute type table
CREATE TABLE attribute_type (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    data_type ENUM('text', 'number', 'boolean', 'date') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES attribute_category(id)
);

-- Product table
CREATE TABLE product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand(id),
    FOREIGN KEY (category_id) REFERENCES product_category(id)
);

-- Product images table
CREATE TABLE product_image (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

-- Product attribute table
CREATE TABLE product_attribute (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    attribute_type_id INT NOT NULL,
    value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(id)
);

-- Product item table (specific variations that can be purchased)
CREATE TABLE product_item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

-- Product variation table (links items to their specific variations)
CREATE TABLE product_variation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    product_item_id INT NOT NULL,
    color_id INT,
    size_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE,
    FOREIGN KEY (product_item_id) REFERENCES product_item(id) ON DELETE CASCADE,
    FOREIGN KEY (color_id) REFERENCES color(id),
    FOREIGN KEY (size_id) REFERENCES size_option(id)
);

-- Junction table for product colors (optional, for tracking available colors per product)
CREATE TABLE product_color (
    product_id INT NOT NULL,
    color_id INT NOT NULL,
    PRIMARY KEY (product_id, color_id),
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE,
    FOREIGN KEY (color_id) REFERENCES color(id)
);

-- CODES FOR INSERTING INTO THE TABLES
-- Insert into brand table
INSERT INTO brand (name, description, logo_url, created_at) VALUES
('Nike', 'Just Do It - Athletic apparel and footwear', 'https://example.com/logos/nike.png', '2025-01-01 09:00:00'),
('Adidas', 'Impossible is Nothing - Sportswear manufacturer', 'https://example.com/logos/adidas.png', '2025-01-02 10:15:00'),
('Apple', 'Think Different - Technology products', 'https://example.com/logos/apple.png', '2025-01-03 11:30:00'),
('Samsung', 'Do What You Can''t - Electronics company', 'https://example.com/logos/samsung.png', '2025-01-04 14:45:00'),
('Levi''s', 'Quality jeans and casual wear', 'https://example.com/logos/levis.png', '2025-01-05 16:20:00');

-- Insert into product_category table (with hierarchy)
INSERT INTO product_category (name, description, parent_category_id, created_at) VALUES
('Electronics', 'Electronic devices and accessories', NULL, '2025-01-06 08:00:00'),
('Clothing', 'Apparel and fashion items', NULL, '2025-01-06 09:30:00'),
('Smartphones', 'Mobile phones with advanced features', 1, '2025-01-07 10:45:00'),
('Laptops', 'Portable computers', 1, '2025-01-07 11:15:00'),
('Men''s Clothing', 'Clothing for men', 2, '2025-01-08 13:20:00'),
('Women''s Clothing', 'Clothing for women', 2, '2025-01-08 14:10:00'),
('Jeans', 'Denim pants', 5, '2025-01-09 15:30:00'),
('T-Shirts', 'Casual short-sleeve shirts', 5, '2025-01-09 16:45:00');

-- Insert into size_category table
INSERT INTO size_category (name, description, created_at) VALUES
('Clothing', 'Standard clothing sizes', '2025-01-10 09:00:00'),
('Shoes', 'Footwear sizes', '2025-01-10 10:30:00'),
('Electronics', 'Device sizes (for cases/accessories)', '2025-01-11 11:45:00');

-- Insert into size_option table
INSERT INTO size_option (category_id, name, description, created_at) VALUES
(1, 'S', 'Small', '2025-01-12 08:15:00'),
(1, 'M', 'Medium', '2025-01-12 09:30:00'),
(1, 'L', 'Large', '2025-01-12 10:45:00'),
(1, 'XL', 'Extra Large', '2025-01-12 11:15:00'),
(2, '8', 'US Size 8', '2025-01-13 13:20:00'),
(2, '9', 'US Size 9', '2025-01-13 14:30:00'),
(2, '10', 'US Size 10', '2025-01-13 15:45:00'),
(3, 'Standard', 'Fits most devices', '2025-01-14 16:00:00'),
(3, 'Plus', 'For larger devices', '2025-01-14 17:15:00');

-- Insert into color table
INSERT INTO color (name, hex_code, created_at) VALUES
('Red', '#FF0000', '2025-01-15 09:00:00'),
('Blue', '#0000FF', '2025-01-15 10:15:00'),
('Black', '#000000', '2025-01-16 11:30:00'),
('White', '#FFFFFF', '2025-01-16 13:45:00'),
('Green', '#00FF00', '2025-01-17 14:00:00'),
('Yellow', '#FFFF00', '2025-01-17 15:15:00'),
('Gray', '#808080', '2025-01-18 16:30:00');

-- Insert into attribute_category table
INSERT INTO attribute_category (name, created_at) VALUES
('Physical', '2025-01-19 08:00:00'),
('Technical', '2025-01-19 09:30:00'),
('Material', '2025-01-20 10:45:00');

-- Insert into attribute_type table
INSERT INTO attribute_type (category_id, name, data_type, created_at) VALUES
(1, 'Weight', 'number', '2025-01-21 11:00:00'),
(1, 'Dimensions', 'text', '2025-01-21 12:15:00'),
(2, 'Processor', 'text', '2025-01-22 13:30:00'),
(2, 'Storage', 'text', '2025-01-22 14:45:00'),
(2, 'RAM', 'text', '2025-01-23 15:00:00'),
(3, 'Fabric', 'text', '2025-01-23 16:15:00'),
(3, 'Care Instructions', 'text', '2025-01-24 17:30:00');

-- Insert into product table
INSERT INTO product (brand_id, category_id, name, description, base_price, created_at) VALUES
(3, 3, 'iPhone 15 Pro', 'Latest Apple smartphone with A17 Pro chip', 999.00, '2025-01-25 09:00:00'),
(4, 3, 'Galaxy S24', 'Samsung flagship with Snapdragon 8 Gen 3', 899.99, '2025-01-26 10:15:00'),
(3, 4, 'MacBook Pro 14"', 'Powerful laptop with M3 Pro chip', 1999.00, '2025-01-27 11:30:00'),
(1, 7, 'Air Jordan 1 Retro', 'Classic basketball sneakers', 180.00, '2025-01-28 13:45:00'),
(5, 7, '501 Original Fit Jeans', 'Classic straight-leg jeans', 69.50, '2025-01-29 14:00:00'),
(2, 8, 'Adidas Originals T-Shirt', 'Cotton t-shirt with logo', 29.99, '2025-01-30 15:15:00');

-- Insert into product_image table
INSERT INTO product_image (product_id, image_url, is_primary, created_at) VALUES
(1, 'https://example.com/products/iphone15pro_1.jpg', TRUE, '2025-02-01 08:00:00'),
(1, 'https://example.com/products/iphone15pro_2.jpg', FALSE, '2025-02-01 09:15:00'),
(2, 'https://example.com/products/galaxys24_1.jpg', TRUE, '2025-02-02 10:30:00'),
(2, 'https://example.com/products/galaxys24_2.jpg', FALSE, '2025-02-02 11:45:00'),
(3, 'https://example.com/products/macbookpro_1.jpg', TRUE, '2025-02-03 13:00:00'),
(4, 'https://example.com/products/jordan1_1.jpg', TRUE, '2025-02-04 14:15:00'),
(5, 'https://example.com/products/levis501_1.jpg', TRUE, '2025-02-05 15:30:00'),
(6, 'https://example.com/products/adidastshirt_1.jpg', TRUE, '2025-02-06 16:45:00');

-- Insert into product_attribute table
INSERT INTO product_attribute (product_id, attribute_type_id, value, created_at) VALUES
(1, 1, '187', '2025-02-07 09:00:00'),  -- iPhone weight in grams
(1, 2, '146.6 x 70.6 x 8.25 mm', '2025-02-07 10:15:00'),
(1, 3, 'A17 Pro', '2025-02-08 11:30:00'),
(1, 4, '256GB', '2025-02-08 13:45:00'),
(2, 1, '168', '2025-02-09 14:00:00'),  -- Galaxy weight in grams
(2, 3, 'Snapdragon 8 Gen 3', '2025-02-09 15:15:00'),
(3, 1, '1600', '2025-02-10 16:30:00'),  -- MacBook weight in grams
(4, 6, 'Leather', '2025-02-11 17:45:00'),
(5, 6, '100% Cotton', '2025-02-12 08:00:00'),
(6, 6, '100% Organic Cotton', '2025-02-13 09:15:00');

-- Insert into product_item table
INSERT INTO product_item (product_id, sku, price, quantity, created_at) VALUES
(1, 'IP15P-256-SLV', 999.00, 50, '2025-02-14 10:30:00'),  -- iPhone Silver
(1, 'IP15P-256-BLK', 999.00, 45, '2025-02-14 11:45:00'),   -- iPhone Black
(2, 'GS24-256-BLK', 899.99, 60, '2025-02-15 13:00:00'),    -- Galaxy Black
(2, 'GS24-256-GRN', 899.99, 40, '2025-02-15 14:15:00'),    -- Galaxy Green
(3, 'MBP14-M3-512', 1999.00, 30, '2025-02-16 15:30:00'),   -- MacBook Pro
(4, 'AJ1-RT-BLK-RD', 180.00, 100, '2025-02-17 16:45:00'),  -- Jordan Black/Red
(5, 'LV501-BLU-32', 69.50, 75, '2025-02-18 08:00:00'),     -- Levi's Blue 32W
(5, 'LV501-BLK-34', 69.50, 60, '2025-02-18 09:15:00'),      -- Levi's Black 34W
(6, 'AD-TS-BLK-M', 29.99, 120, '2025-02-19 10:30:00'),      -- Adidas T-Shirt Black M
(6, 'AD-TS-WHT-L', 29.99, 90, '2025-02-19 11:45:00');       -- Adidas T-Shirt White L

-- Insert into product_variation table
INSERT INTO product_variation (product_id, product_item_id, color_id, size_id, created_at) VALUES
(1, 1, 4, NULL, '2025-02-20 13:00:00'),   -- iPhone Silver (no size)
(1, 2, 3, NULL, '2025-02-20 14:15:00'),    -- iPhone Black (no size)
(2, 3, 3, NULL, '2025-02-21 15:30:00'),    -- Galaxy Black (no size)
(2, 4, 5, NULL, '2025-02-21 16:45:00'),    -- Galaxy Green (no size)
(3, 5, 3, NULL, '2025-02-22 08:00:00'),    -- MacBook Black (no size)
(4, 6, 3, 5, '2025-02-23 09:15:00'),       -- Jordan Black/Red Size 8
(4, 6, 3, 6, '2025-02-23 10:30:00'),       -- Jordan Black/Red Size 9
(5, 7, 2, NULL, '2025-02-24 11:45:00'),    -- Levi's Blue (size in SKU)
(5, 8, 3, NULL, '2025-02-24 13:00:00'),    -- Levi's Black (size in SKU)
(6, 9, 3, 2, '2025-02-25 14:15:00'),       -- Adidas T-Shirt Black M
(6, 10, 4, 3, '2025-02-25 15:30:00');      -- Adidas T-Shirt White L

-- Insert into product_color table
INSERT INTO product_color (product_id, color_id) VALUES
(1, 3),  -- iPhone comes in Black
(1, 4),  -- and Silver
(2, 3),  -- Galaxy comes in Black
(2, 5),  -- and Green
(4, 3),  -- Jordan comes in Black
(5, 2),  -- Levi's comes in Blue
(5, 3),  -- and Black
(6, 3),  -- Adidas T-Shirt comes in Black
(6, 4);  -- and White