<!--

This stylesheet allows the SPARQL XML Results format to be transformed into a KML 2.0 file
for overlaying on Google Earth or Google Maps.

QUERY FORMATTING

The stylesheet expects the SPARQL query results to be constructed in a specific way. This allows 
the stylesheet to reliably extract some required fields from the query results. A SPARQL select 
query returns a number results (rows) that each have some named bindings (columns). The stylesheet 
uses the following named bindings in order to construct the output:

* name - used to generate the name of the placemark
* description - used to generate the description of the placemark
* lat - latitude of the placemark
* long - longitude of the placemark

All additional results bindings are currently ignored.

XSLT PARAMETERS

* doc-name
* doc-desc

 -->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sparql="http://www.w3.org/2005/sparql-results#" 
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:kml="http://www.opengis.net/kml/2.2" 
	xmlns="http://www.opengis.net/kml/2.2" 
	version="1.0" 
	exclude-result-prefixes="sparql rdf kml">

	<xsl:output 
		indent="yes" 
		method="xml" 
		omit-xml-declaration="yes" 
		media-type="application/vnd.google-earth.kml+xml"/>

	<xsl:param name="doc-name"/>
	<xsl:param name="doc-desc"/>
    
	<xsl:template match="/">
	   <kml>   	
	     <Document>
		   <name>
		    <xsl:choose>
	        	<xsl:when test="$doc-name"><xsl:value-of select="$doc-name"/></xsl:when>
	        	<xsl:otherwise><xsl:text>SPARQL Query Results</xsl:text></xsl:otherwise>
	      	</xsl:choose>
	       </name>
		   <description>
		    <xsl:choose>
	        	<xsl:when test="$doc-desc"><xsl:value-of select="$doc-desc"/></xsl:when>
	        	<xsl:otherwise><xsl:text>SPARQL Query Results</xsl:text></xsl:otherwise>
	      	</xsl:choose>
		   </description>
	      <xsl:apply-templates select="//sparql:result"/>
	     </Document>
	   </kml>
	</xsl:template>

	<!-- Ignore head element -->
	<xsl:template match="sparql:head"/>

	<xsl:template match="sparql:results">
	      <xsl:apply-templates select="sparql:result"/>
	</xsl:template>

	<!-- Process results element -->
	<xsl:template match="sparql:result">
	  <Placemark>
	    <name><xsl:value-of select="sparql:binding[@name='name']/sparql:literal"/></name>	  
	    <description><xsl:value-of select="sparql:binding[@name='description']/sparql:literal"/></description>
	    <Point>
	    	<coordinates>
	    	<xsl:value-of select="sparql:binding[@name='long']/sparql:literal"/><xsl:text>,</xsl:text>
	    	<xsl:value-of select="sparql:binding[@name='lat']/sparql:literal"/>
	    	</coordinates>
	    </Point>
	  </Placemark>
	</xsl:template>
   
   
</xsl:stylesheet>