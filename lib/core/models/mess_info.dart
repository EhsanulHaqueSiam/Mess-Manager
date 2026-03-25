class MessInfo {
  final String wifiPassword;
  final String landlordName;
  final String landlordPhone;
  final String policePhone;
  final String fireServicePhone;
  final String ambulancePhone;
  final String gateCloseTime;
  final String wifiOffTime;
  final String rule1;
  final String rule2;
  final String descoAccount;
  final String gasAccount;

  const MessInfo({
    this.wifiPassword = 'MessWifi@2026',
    this.landlordName = 'Mr. Rahim',
    this.landlordPhone = '+880 1712-345678',
    this.policePhone = '999',
    this.fireServicePhone = '199',
    this.ambulancePhone = '199',
    this.gateCloseTime = '10 PM',
    this.wifiOffTime = '11 PM',
    this.rule1 = 'No smoking inside rooms',
    this.rule2 = 'Guests allowed until 8 PM',
    this.descoAccount = '12345678',
    this.gasAccount = '1234',
  });

  MessInfo copyWith({
    String? wifiPassword,
    String? landlordName,
    String? landlordPhone,
    String? policePhone,
    String? fireServicePhone,
    String? ambulancePhone,
    String? gateCloseTime,
    String? wifiOffTime,
    String? rule1,
    String? rule2,
    String? descoAccount,
    String? gasAccount,
  }) {
    return MessInfo(
      wifiPassword: wifiPassword ?? this.wifiPassword,
      landlordName: landlordName ?? this.landlordName,
      landlordPhone: landlordPhone ?? this.landlordPhone,
      policePhone: policePhone ?? this.policePhone,
      fireServicePhone: fireServicePhone ?? this.fireServicePhone,
      ambulancePhone: ambulancePhone ?? this.ambulancePhone,
      gateCloseTime: gateCloseTime ?? this.gateCloseTime,
      wifiOffTime: wifiOffTime ?? this.wifiOffTime,
      rule1: rule1 ?? this.rule1,
      rule2: rule2 ?? this.rule2,
      descoAccount: descoAccount ?? this.descoAccount,
      gasAccount: gasAccount ?? this.gasAccount,
    );
  }

  factory MessInfo.fromJson(Map<String, dynamic> json) {
    return MessInfo(
      wifiPassword: json['wifiPassword'] as String? ?? 'MessWifi@2026',
      landlordName: json['landlordName'] as String? ?? 'Mr. Rahim',
      landlordPhone: json['landlordPhone'] as String? ?? '+880 1712-345678',
      policePhone: json['policePhone'] as String? ?? '999',
      fireServicePhone: json['fireServicePhone'] as String? ?? '199',
      ambulancePhone: json['ambulancePhone'] as String? ?? '199',
      gateCloseTime: json['gateCloseTime'] as String? ?? '10 PM',
      wifiOffTime: json['wifiOffTime'] as String? ?? '11 PM',
      rule1: json['rule1'] as String? ?? 'No smoking inside rooms',
      rule2: json['rule2'] as String? ?? 'Guests allowed until 8 PM',
      descoAccount: json['descoAccount'] as String? ?? '12345678',
      gasAccount: json['gasAccount'] as String? ?? '1234',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wifiPassword': wifiPassword,
      'landlordName': landlordName,
      'landlordPhone': landlordPhone,
      'policePhone': policePhone,
      'fireServicePhone': fireServicePhone,
      'ambulancePhone': ambulancePhone,
      'gateCloseTime': gateCloseTime,
      'wifiOffTime': wifiOffTime,
      'rule1': rule1,
      'rule2': rule2,
      'descoAccount': descoAccount,
      'gasAccount': gasAccount,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessInfo &&
          runtimeType == other.runtimeType &&
          wifiPassword == other.wifiPassword &&
          landlordName == other.landlordName &&
          landlordPhone == other.landlordPhone &&
          policePhone == other.policePhone &&
          fireServicePhone == other.fireServicePhone &&
          ambulancePhone == other.ambulancePhone &&
          gateCloseTime == other.gateCloseTime &&
          wifiOffTime == other.wifiOffTime &&
          rule1 == other.rule1 &&
          rule2 == other.rule2 &&
          descoAccount == other.descoAccount &&
          gasAccount == other.gasAccount;

  @override
  int get hashCode => Object.hash(
        wifiPassword,
        landlordName,
        landlordPhone,
        policePhone,
        fireServicePhone,
        ambulancePhone,
        gateCloseTime,
        wifiOffTime,
        rule1,
        rule2,
        descoAccount,
        gasAccount,
      );

  @override
  String toString() {
    return 'MessInfo(wifiPassword: $wifiPassword, landlordName: $landlordName, landlordPhone: $landlordPhone, policePhone: $policePhone, fireServicePhone: $fireServicePhone, ambulancePhone: $ambulancePhone, gateCloseTime: $gateCloseTime, wifiOffTime: $wifiOffTime, rule1: $rule1, rule2: $rule2, descoAccount: $descoAccount, gasAccount: $gasAccount)';
  }
}
