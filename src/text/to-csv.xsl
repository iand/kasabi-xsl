<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:res="http://www.w3.org/2005/sparql-results#"
  exclude-result-prefixes="res xsl">

  <xsl:output method="text" omit-xml-declaration="yes"/>
  <xsl:strip-space elements="res:binding res:literal res:url" />
  
  <xsl:template match="res:sparql">
    <xsl:for-each select="res:head/res:variable">"<xsl:value-of select="@name"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each><xsl:text>&#10;</xsl:text>
    <xsl:for-each select="res:results/res:result">
      <xsl:for-each select="res:binding">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if><xsl:if test="position()=last()"><xsl:text>&#10;</xsl:text></xsl:if>
      </xsl:for-each>
    </xsl:for-each>    
  </xsl:template>

</xsl:stylesheet>
