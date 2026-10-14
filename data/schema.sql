-- CUPS Demo Database Schema
-- 6 tables · 27,113 records · 60-day period (Aug 14 – Oct 12, 2026)

CREATE TABLE cafes (
    cafe_id       VARCHAR(50) PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    chain         VARCHAR(50),
    district      VARCHAR(20),
    address       TEXT,
    lat           DECIMAL(8,5),
    lng           DECIMAL(8,5),
    prep_minutes  INT
);

CREATE TABLE customers (
    customer_id   VARCHAR(10) PRIMARY KEY,
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    gender        CHAR(1),           -- M / Ž
    age_group     VARCHAR(10),
    persona       VARCHAR(50),       -- ranní dojíždějící, student, etc.
    platform      VARCHAR(20),
    phone_masked  VARCHAR(20),
    signup_date   DATE,
    home_cafe_id  VARCHAR(50) REFERENCES cafes(cafe_id),
    home_district VARCHAR(20),
    segment       VARCHAR(20)        -- vracející se / jednorázový
);

CREATE TABLE products (
    product_id    VARCHAR(30) PRIMARY KEY,
    product       VARCHAR(50) NOT NULL,
    category      VARCHAR(20),       -- Káva, Ledová káva, Matcha, Čaj, Jídlo, Komba
    base_price    INT,
    is_combo      BOOLEAN
);

CREATE TABLE promo_codes (
    code             VARCHAR(20) PRIMARY KEY,
    percent          INT,
    first_order_only BOOLEAN,
    scope            VARCHAR(50)
);

CREATE TABLE orders (
    order_id       VARCHAR(20) PRIMARY KEY,
    order_number   INT,
    pickup_code    VARCHAR(5),
    cafe_id        VARCHAR(50) REFERENCES cafes(cafe_id),
    customer_id    VARCHAR(10) REFERENCES customers(customer_id),
    created_at     TIMESTAMP,
    date           DATE,
    weekday        VARCHAR(5),
    hour           INT,
    status         VARCHAR(15),      -- picked_up / cancelled
    cancelled_by   VARCHAR(20),
    order_type     VARCHAR(20),      -- Na místě / S sebou
    pickup_mode    VARCHAR(20),      -- co nejdřív / na čas
    pickup_at      TIMESTAMP,
    accepted_at    TIMESTAMP,
    ready_at       TIMESTAMP,
    picked_up_at   TIMESTAMP,
    cancelled_at   TIMESTAMP,
    prep_minutes   DECIMAL(4,1),
    items_count    INT,
    subtotal       INT,
    promo_code     VARCHAR(20),
    discount       INT,
    total          INT,
    is_first_order BOOLEAN,
    platform       VARCHAR(20)
);

CREATE TABLE order_items (
    item_id        INT PRIMARY KEY,
    order_id       VARCHAR(20) REFERENCES orders(order_id),
    cafe_id        VARCHAR(50) REFERENCES cafes(cafe_id),
    product_id     VARCHAR(30) REFERENCES products(product_id),
    product        VARCHAR(50),
    category       VARCHAR(20),
    qty            INT,
    base_price     INT,
    options_price  INT,
    unit_price     INT,
    line_total     INT,
    size           VARCHAR(10),
    milk           VARCHAR(20),
    syrup          VARCHAR(20),
    sugar          VARCHAR(10),
    options_text   TEXT
);
