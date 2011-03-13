<?xml version="1.0" encoding="UTF-8"?>
<!--

sparql-rss.xsl, version 0.1 (2005-05-04):
XSLT for transformation of SPARQL Query Results XML Format into RSS 1.0.

Background, changes and more information:
http://www.wasab.dk/morten/blog/archives/2005/05/04/sparql-conversions-xslt

Copyright (c) 2005 Morten Frederiksen
License: http://www.gnu.org/licenses/gpl
     or: http://www.w3.org/Consortium/Legal/2002/copyright-software-20021231

Updated by Leigh Dodds, May 2006:

- fixed namespace
- removed backwards compatibility
- added title/description params
- removed sparql-* params
- renamed _uri -> channel

-->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dawg="http://www.w3.org/2005/sparql-results#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rss="http://purl.org/rss/1.0/" xmlns:dc="http://purl.org/dc/elements/1.1/" exclude-result-prefixes="dawg" version="1.0">
<xsl:output indent="yes" method="xml" media-type="application/xml"/>

<xsl:param name="_now" select="false()"/>
<xsl:param name="_id"/>
<xsl:param name="channel"/>
<xsl:param name="title"/>
<xsl:param name="description"/>

<!-- Create document from SPARQL Query Results XML Format -->
<xsl:template match="/">
   <rdf:RDF>
      <xsl:apply-templates mode="root" select="/dawg:sparql/*"/>
   </rdf:RDF>
</xsl:template>

<!-- Ignore head element -->
<xsl:template mode="root" match="dawg:head"/>

<!-- Process results element -->
<xsl:template mode="root" match="dawg:results[dawg:result/dawg:binding/dawg:uri]">
   <!-- Determine name of binding to use as rss:link for each item -->
   <xsl:variable name="linkname">
      <xsl:apply-templates mode="linkname" select="."/>
   </xsl:variable>
   <!-- Determine name of binding to use as rss:title for each item -->
   <xsl:variable name="titlename">
      <xsl:apply-templates mode="titlename" select="."/>
   </xsl:variable>
   <!-- Create channel... -->
   <rss:channel rdf:about="">
      <rss:title>
      <xsl:choose>
        <xsl:when test="$title"><xsl:value-of select="$title"/></xsl:when>
        <xsl:otherwise><xsl:text>SPARQL Query Results</xsl:text></xsl:otherwise>
      </xsl:choose>
      </rss:title>
      <rss:link>
         <xsl:value-of select="$channel"/>
      </rss:link>
      <rss:description>
         <xsl:choose>
           <xsl:when test="$description"><xsl:value-of select="$description"/></xsl:when>
           <xsl:otherwise><xsl:text>Results for SPARQL Query</xsl:text></xsl:otherwise>
         </xsl:choose>      
      </rss:description>
      <xsl:if test="$_now">
         <dc:date>
            <xsl:value-of select="$_now"/>
         </dc:date>
      </xsl:if>
      <rss:items>
         <rdf:Seq>
            <xsl:apply-templates mode="result-sequence" select="dawg:result[dawg:binding[@name=$linkname and dawg:uri]]"/>
         </rdf:Seq>
      </rss:items>
   </rss:channel>
   <!-- Create each item, only the ones with an rss:link binding -->
   <xsl:apply-templates mode="result-item" select="dawg:result[dawg:binding[@name=$linkname and dawg:uri]]">
      <xsl:with-param name="linkname" select="$linkname"/>
      <xsl:with-param name="titlename" select="$titlename"/>
   </xsl:apply-templates>
</xsl:template>

<!-- First order elements other than head or results must be an error -->
<xsl:template mode="root" match="*">
   <rdf:Description rdf:about="">
      <dc:title>
         <xsl:text>Unknown or incomplete result format. Namespace of root element is </xsl:text>
         <xsl:value-of select="namespace-uri(/*[1])"/>
         <xsl:text>.</xsl:text>
      </dc:title>
   </rdf:Description>
</xsl:template>

<!-- Determine name of binding to use for rss:link for each item -->
<xsl:template mode="linkname" match="*">
   <xsl:choose>
      <xsl:when test="dawg:result/dawg:binding[@name='rsslink' and dawg:uri]">
         <xsl:text>rsslink</xsl:text>
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="dawg:result/dawg:binding[dawg:uri][1]/@name"/>
      </xsl:otherwise>
   </xsl:choose>
</xsl:template>

<!-- Determine name of binding to use for rss:title for each item -->
<xsl:template mode="titlename" match="*">
   <xsl:choose>
      <xsl:when test="dawg:result/dawg:binding[@name='rsstitle' and dawg:literal]">
         <xsl:text>rsstitle</xsl:text>
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="dawg:result/dawg:binding[dawg:literal][1]/@name"/>
      </xsl:otherwise>
   </xsl:choose>
</xsl:template>

<!-- Process result element for reference from channel to each item -->
<xsl:template mode="result-sequence" match="*">
   <rdf:li rdf:resource="#{generate-id()}{$_id}"/>
</xsl:template>

<!-- Process result element for item creation -->
<xsl:template mode="result-item" match="*">
   <xsl:param name="linkname"/>
   <xsl:param name="titlename"/>
   <rss:item rdf:about="#{generate-id()}{$_id}">
      <rss:link>
         <xsl:apply-templates mode="value" select="dawg:binding[@name=$linkname]"/>
      </rss:link>
      <rss:title>
         <xsl:apply-templates mode="value" select="dawg:binding[@name=$titlename]"/>
      </rss:title>
      <!-- Generate description from other non-link/title bindings -->
      <xsl:variable name="description">
         <xsl:for-each select="dawg:binding[@name!=$linkname and @name!=$titlename]">
            <xsl:if test="position()!=1">
               <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="@name"/>
            <xsl:text>: </xsl:text>
            <xsl:apply-templates mode="value" select="."/>
         </xsl:for-each>
      </xsl:variable>
      <xsl:if test="string-length($description)!=0">
         <rss:description>
            <xsl:value-of select="$description"/>
         </rss:description>
      </xsl:if>
   </rss:item>
</xsl:template>

<!-- String value of binding for second draft -->
<xsl:template mode="value" match="dawg:binding">
   <xsl:choose>
      <xsl:when test="dawg:uri">
         <xsl:value-of select="dawg:uri"/>
      </xsl:when>
      <xsl:when test="dawg:bnode">
         <xsl:text>(</xsl:text>
         <xsl:value-of select="dawg:bnode"/>
         <xsl:text>)</xsl:text>
      </xsl:when>
      <xsl:when test="dawg:literal[@datatype]">
         <xsl:value-of select="dawg:literal/text()"/>
         <xsl:text> ^^ </xsl:text>
         <xsl:value-of select="dawg:literal/@datatype"/>
      </xsl:when>
      <xsl:when test="dawg:literal[@xml:lang]">
         <xsl:value-of select="dawg:literal/text()"/>
         <xsl:text> @ </xsl:text>
         <xsl:value-of select="dawg:literal/@xml:lang"/>
      </xsl:when>
      <xsl:when test="dawg:literal">
         <xsl:value-of select="dawg:literal/text()"/>
      </xsl:when>
      <xsl:otherwise>
         <xsl:text>-</xsl:text>
      </xsl:otherwise>
   </xsl:choose>
</xsl:template>

</xsl:transform>