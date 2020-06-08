<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method='html' version='1.0' encoding='UTF-8' indent='yes'/>

<xsl:template match="/">
  <html>
  <body>
  <h2>Exercise 4</h2>
    <table border="1">
      <tr bgcolor="#9acd32">
        <th align="left">Name</th>
        <th align="left">Age</th>
        <th align="left">Grade</th>
      </tr>
      <xsl:for-each select="CLASS/STUDENT">
      <xsl:if test="GRADE='A'">
      <tr>
        <td><xsl:value-of select="NAME"/></td>
        <td><xsl:value-of select="AGE"/></td>
		    <td><xsl:value-of select="GRADE"/></td>
      </tr>
      </xsl:if>
      </xsl:for-each>
    </table>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>