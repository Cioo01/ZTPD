<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
        <html>
            <body>
                <h1> ZESPOŁY: </h1>
<!--A                -->
<!--                <ol>-->
<!--                    <xsl:for-each select="ZESPOLY/ROW">-->
<!--                        <li>-->
<!--                            <xsl:value-of select="NAZWA"/>-->
<!--                        </li>-->
<!--                    </xsl:for-each>-->
<!--                </ol>-->


<!--B                -->
                <ol>
                    <xsl:apply-templates select="ZESPOLY/ROW" mode="list"/>
<!--                    <br/>-->
<!--                    <xsl:apply-templates select="." mode="details"/>-->
                </ol>

                <div>
                    <xsl:apply-templates select="ZESPOLY/ROW" mode="details"/>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="*" mode="list">
        <li>
            <a href="#{NAZWA}">
            <xsl:value-of select="NAZWA"/>
            </a>
        </li>
    </xsl:template>


    <xsl:template match="*" mode="details">
        <b id="{NAZWA}">NAZWA: <xsl:value-of select="NAZWA"/></b><br></br>
        <b>ADRES: <xsl:value-of select="ADRES"/></b><br></br>
        <xsl:variable name="employeeCount" select="count(PRACOWNICY/ROW[ID_ZESP = current()/ID_ZESP])"/>
        <xsl:if test="$employeeCount > 0">
        <table border="1">
            <tr>
                <th>Nazwisko</th>
                <th>Etat</th>
                <th>Zatrudniony</th>
                <th>Płaca pod.</th>
                <th>Szef</th>
            </tr>
            <xsl:apply-templates select="PRACOWNICY/ROW" mode="employees">
            <xsl:sort select="NAZWISKO"/>
            </xsl:apply-templates>

        </table>
        </xsl:if>
        Liczba pracowników: <xsl:value-of select="count(PRACOWNICY/ROW[ID_ZESP = current()/ID_ZESP])"/>
        <br></br><br></br>
    </xsl:template>

    <xsl:template match="*" mode="employees">
        <tr>
            <td><xsl:value-of select="NAZWISKO"/></td>
            <td><xsl:value-of select="ETAT"/></td>
            <td><xsl:value-of select="ZATRUDNIONY"/></td>
            <td><xsl:value-of select="PLACA_POD"/></td>
            <td>
                <xsl:choose>
                    <xsl:when test="ID_SZEFA">
                        <xsl:value-of select="//ROW/PRACOWNICY/ROW[ID_PRAC = current()/ID_SZEFA]/NAZWISKO"/>
                    </xsl:when>
                    <xsl:otherwise>brak</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>