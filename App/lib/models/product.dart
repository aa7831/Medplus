//product data model

class Product{
    final String description;
    final String form;
    final String name;
    final List<String> pharmacies;
    final List <int> price;

    const Product({
      required this.description,
      required this.price,
      required this.form,
      required this.name,
      required this.pharmacies,
      }
    );

    Map <String, dynamic> toJson() => {
        'name' : name,
        'description': description,
        'price' : price,
        'pharmacies' : pharmacies,
        'form' : form,
    };
}

