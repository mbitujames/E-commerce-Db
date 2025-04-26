# E-commerce-Db
## Group 14 - Assignment

This project defines the schema and initial data for an e-commerce database. The database is designed to manage products, brands, categories, attributes, variations, and other related entities for an e-commerce platform.

## Database Schema

The database consists of the following tables:

1. **brand**: Stores information about product brands.
2. **product_category**: Defines product categories with support for hierarchical relationships.
3. **size_category**: Defines categories for size options (e.g., clothing, shoes).
4. **size_option**: Stores specific size options for products.
5. **color**: Stores color options with their names and hex codes.
6. **attribute_category**: Groups attributes into categories (e.g., physical, technical).
7. **attribute_type**: Defines specific attributes for products (e.g., weight, dimensions).
8. **product**: Stores product details, including brand and category.
9. **product_image**: Stores product images with support for primary and secondary images.
10. **product_attribute**: Links products to their attributes and values.
11. **product_item**: Represents purchasable variations of a product (e.g., different SKUs).
12. **product_variation**: Links product items to specific variations (e.g., color, size).
13. **product_color**: Tracks available colors for each product.

## Features

- **Hierarchical Categories**: Products can belong to categories with parent-child relationships.
- **Product Variations**: Supports variations like size and color for specific product items.
- **Attributes**: Allows defining custom attributes for products, grouped into categories.
- **Images**: Supports multiple images per product with a primary image flag.
- **Initial Data**: Includes sample data for brands, categories, products, and variations.

## How to Use

1. **Create the Database**:
   Run the SQL script `ecommerce.sql` to create the database and tables.

   ```sql
   CREATE DATABASE ecommerce;
   USE ecommerce;

