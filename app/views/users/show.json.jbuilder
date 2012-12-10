
json.(@user, *(User.attribute_names - ["password_digest", "created_at", "updated_at"] + ["category_ids"]))
