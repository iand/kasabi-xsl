<?xml version="1.0" encoding="iso-8859-1"?>
<!--

This stylesheet allows the SPARQL XML Results format to be transformed into a simple 
HTML file containing a table

-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:sparql="http://www.w3.org/2005/sparql-results#"
  exclude-result-prefixes="sparql xsl">

  <xsl:output method="xml" omit-xml-declaration="yes" 		indent="yes" />
  <xsl:strip-space elements="sparql:binding sparql:literal sparql:url" />
  
  <xsl:template match="sparql:sparql">
    <html>
      <body>
        <table>
          <tr>
            <xsl:for-each select="sparql:head/sparql:variable">
              <th>
                <xsl:value-of select="@name"/>
              </th>
            </xsl:for-each>
          </tr>
          <xsl:for-each select="sparql:results/sparql:result">
            <tr>
              <xsl:for-each select="sparql:binding">
                <td>
                  <xsl:if test="sparql:literal[@datatype='http://www.w3.org/2001/XMLSchema#decimal' or @datatype='http://www.w3.org/2001/XMLSchema#float' or @datatype='http://www.w3.org/2001/XMLSchema#doublle' or @datatype='http://www.w3.org/2001/XMLSchema#integer' or @datatype='http://www.w3.org/2001/XMLSchema#nonPositiveInteger' or @datatype='http://www.w3.org/2001/XMLSchema#negativeInteger' or @datatype='http://www.w3.org/2001/XMLSchema#long' or @datatype='http://www.w3.org/2001/XMLSchema#int' or @datatype='http://www.w3.org/2001/XMLSchema#short' or @datatype='http://www.w3.org/2001/XMLSchema#byte' or @datatype='http://www.w3.org/2001/XMLSchema#nonNegativeInteger' or @datatype='http://www.w3.org/2001/XMLSchema#unsignedLong' or @datatype='http://www.w3.org/2001/XMLSchema#unsignedInt' or @datatype='http://www.w3.org/2001/XMLSchema#unsignedShort' or @datatype='http://www.w3.org/2001/XMLSchema#positiveInteger']">
                    <xsl:attribute name="align">right</xsl:attribute>
                  </xsl:if>
                  <xsl:choose>
                    <xsl:when test="sparql:uri and starts-with(sparql:uri, 'http')">
                      <a href="{sparql:uri}">
                        <xsl:value-of select="."/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="."/>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </xsl:for-each>
            </tr>
          </xsl:for-each>    
        </table>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
