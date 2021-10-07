const String GQL_PRODUCTS_AND_CATEGORY_INFO = """
query allProductCategories {
  allProductCategories {
    id
    title
    products {
      id
      title
      description
      price
      photo
    }
  }
}
""";
