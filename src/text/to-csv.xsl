<!--

This stylesheet allows the SPARQL XML Results format to be transformed into a simple 
quoted CSV file

-->
<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:sparql="http://www.w3.org/2005/sparql-results#"
  exclude-result-prefixes="sparql xsl">

  <xsl:output method="text" omit-xml-declaration="yes"/>
  <xsl:strip-space elements="sparql:binding sparql:literal sparql:url" />
  
  <xsl:template match="sparql:sparql">
    <xsl:for-each select="sparql:head/sparql:variable">"<xsl:value-of select="@name"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each><xsl:text>&#10;</xsl:text>
    <xsl:for-each select="sparql:results/sparql:result">
      <xsl:for-each select="sparql:binding">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if><xsl:if test="position()=last()"><xsl:text>&#10;</xsl:text></xsl:if>
      </xsl:for-each>
    </xsl:for-each>    
  </xsl:template>

</xsl:stylesheet>
