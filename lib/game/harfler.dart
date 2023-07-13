enum Harf {
  a("A", 1, 50),
  b("B", 3, 15),
  c("C", 4, 10),
  c_("Ç", 4, 10),
  d("D", 3, 15),
  e("E", 1, 45),
  f("F", 7, 5),
  g("G", 5, 5),
  g_("Ğ", 8, 5),
  h("H", 5, 5),
  i_("I", 2, 25),
  i("İ", 1, 35),
  j("J", 10, 5),
  k("K", 1, 35),
  l("L", 1, 40),
  m("M", 2, 35),
  n("N", 1, 25),
  o("O", 2, 10),
  o_("Ö", 7, 5),
  p("P", 5, 5),
  r("R", 1, 30),
  s("S", 2, 20),
  s_("Ş", 4, 15),
  t("T", 1, 25),
  u("U", 2, 15),
  u_("Ü", 3, 10),
  v("V", 7, 5),
  y("Y", 3, 15),
  z("Z", 4, 10);

  final String harf;
  final int point;
  final int rate;

  const Harf(this.harf, this.point, this.rate);
}
