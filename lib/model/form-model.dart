class DynamicForm {
  String id;
  String title;
  Settings settings;
  List<WelcomeScreens> welcomeScreens;
  List<ThankyouScreens> thankyouScreens;
  List<Fields> fields;

  DynamicForm(
      {this.id,
      this.title,
      this.settings,
      this.welcomeScreens,
      this.thankyouScreens,
      this.fields});

  DynamicForm.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
    if (json['welcome_screens'] != null) {
      welcomeScreens = new List<WelcomeScreens>();
      json['welcome_screens'].forEach((v) {
        welcomeScreens.add(new WelcomeScreens.fromJson(v));
      });
    }
    if (json['thankyou_screens'] != null) {
      thankyouScreens = new List<ThankyouScreens>();
      json['thankyou_screens'].forEach((v) {
        thankyouScreens.add(new ThankyouScreens.fromJson(v));
      });
    }
    if (json['fields'] != null) {
      fields = new List<Fields>();
      json['fields'].forEach((v) {
        fields.add(new Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.settings != null) {
      data['settings'] = this.settings.toJson();
    }
    if (this.welcomeScreens != null) {
      data['welcome_screens'] =
          this.welcomeScreens.map((v) => v.toJson()).toList();
    }
    if (this.thankyouScreens != null) {
      data['thankyou_screens'] =
          this.thankyouScreens.map((v) => v.toJson()).toList();
    }
    if (this.fields != null) {
      data['fields'] = this.fields.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Settings {
  String language;
  String progressBar;
  bool showProgressBar;

  Settings({this.language, this.progressBar, this.showProgressBar});

  Settings.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    progressBar = json['progress_bar'];
    showProgressBar = json['show_progress_bar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['language'] = this.language;
    data['progress_bar'] = this.progressBar;
    data['show_progress_bar'] = this.showProgressBar;
    return data;
  }
}

class WelcomeScreens {
  String title;
  Properties properties;

  WelcomeScreens({this.title, this.properties});

  WelcomeScreens.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.properties != null) {
      data['properties'] = this.properties.toJson();
    }
    return data;
  }
}

class Properties {
  bool showButton;
  String description;
  String buttonText;

  Properties({this.showButton, this.description, this.buttonText});

  Properties.fromJson(Map<String, dynamic> json) {
    showButton = json['show_button'];
    description = json['description'];
    buttonText = json['button_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['show_button'] = this.showButton;
    data['description'] = this.description;
    data['button_text'] = this.buttonText;
    return data;
  }
}

class ThankyouScreens {
  String title;
  Properties properties;

  ThankyouScreens({this.title, this.properties});

  ThankyouScreens.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.properties != null) {
      data['properties'] = this.properties.toJson();
    }
    return data;
  }
}

class Fields {
  String id;
  String title;
  Validations validations;
  Map<String, dynamic> properties;
  String type;

  Fields({this.id, this.title, this.validations, this.type});

  Fields.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    validations = json['validations'] != null
        ? new Validations.fromJson(json['validations'])
        : null;
    properties = json['properties'] ?? {"no": true};
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.validations != null) {
      data['validations'] = this.validations.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class Validations {
  bool required;

  Validations({this.required});

  Validations.fromJson(Map<String, dynamic> json) {
    required = json['required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['required'] = this.required;
    return data;
  }
}
