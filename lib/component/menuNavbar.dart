import 'package:flutter/material.dart';

import 'genColor.dart';

class MenuNavbar {
  const MenuNavbar(this.title, this.icon);
  final String title;
  final IconData icon;
}

const List<MenuNavbar> allDestinations = <MenuNavbar>[
  MenuNavbar('Beranda', Icons.home_outlined),
  MenuNavbar('Pengajuan', Icons.assignment),
  MenuNavbar('Berita', Icons.connected_tv_outlined),
  MenuNavbar('Profil', Icons.account_box_outlined),
];