-- LOCATION TABLE
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    location_name VARCHAR(100) NOT NULL,
    coordinates VARCHAR(100) NOT NULL
);

-- PRODUCTS TABLE
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    qr_code VARCHAR(100) UNIQUE NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    product_price DECIMAL(10, 2) NOT NULL,
    product_category VARCHAR(100),
    product_quantity INT DEFAULT 0,
    product_size VARCHAR(50),
    location_id INT,
    CONSTRAINT fk_location FOREIGN KEY (location_id) REFERENCES locations (id) ON DELETE SET NULL
);

-- USERS TABLE
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL
);


INSERT INTO
    locations (
        store_name,
        location_name,
        coordinates
    )
VALUES (
        'Main Store',
        'Room A',
        'Shelf A1'
    ),
    (
        'Main Store',
        'Room B',
        'Shelf B2'
    ),
    (
        'Branch 1',
        'Storage Room',
        'Shelf C3'
    );


INSERT INTO
    products (
        qr_code,
        product_name,
        product_price,
        product_category,
        product_quantity,
        product_size,
        location_id
    )
VALUES (
        'QR001',
        'T-Shirt',
        299.99,
        'Clothing',
        50,
        'Medium',
        1
    ),
    (
        'QR002',
        'Jeans',
        799.50,
        'Clothing',
        30,
        'Large',
        2
    ),
    (
        'QR003',
        'Sneakers',
        1499.00,
        'Footwear',
        20,
        'Size 42',
        2
    ),
    (
        'QR004',
        'Cap',
        199.75,
        'Accessories',
        100,
        'Free Size',
        1
    ),
    (
        'QR005',
        'Jacket',
        1299.00,
        'Clothing',
        15,
        'XL',
        3
    );


INSERT INTO
    users (name, role)
VALUES ('Tom', 'Admin'),
    ('Sarah', 'Staff'),
    ('John', 'Inventory Manager');