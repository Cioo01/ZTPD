(:28:)
(:for $k in doc('file:///C:/Users/kkbac/source/XPath-XSLT/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[substring(NAZWA, 1, 1) = substring(STOLICA, 1, 1)]:)

(:29:)
(:for $k in doc('file:///C:/Users/kkbac/source/XPath-XSLT/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[starts-with(NAZWA,'A')]:)
(:return <KRAJ>:)
(: {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:30:)
(:doc('file:///C:/Users/kkbac/source/XPath-XSLT/XPath-XSLT/swiat.xml')//KRAJ:)

(:32:)
(:doc('file:///C:/Users/kkbac/source/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//NAZWISKO:)

(:33:)
(:doc('file:///C:/Users/kkbac/source/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//ROW[NAZWA='SYSTEMY EKSPERCKIE']//NAZWISKO:)

(:34:)
(:count(doc('file:///C:/Users/kkbac/source/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//ROW[ID_ZESP=10]/PRACOWNICY/ROW):)

(:35:)
(:doc('file:///C:/Users/kkbac/source/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//ROW[ID_SZEFA=100]/NAZWISKO:)

(:36:)
(:sum(doc('file:///C:/Users/kkbac/source/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//ROW[ID_ZESP=//ROW[NAZWISKO='BRZEZINSKI']/ID_ZESP]//PLACA_POD):)