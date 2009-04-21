<?xml version="1.0" encoding="UTF-8"?>

<!-- Google Sitmaps Stylesheets (GSStylesheets)
     Project Home: http://sourceforge.net/projects/gstoolbox
     Copyright (c) 2005 Baccou Bonneville SARL (http://www.baccoubonneville.com)
     License http://www.gnu.org/copyleft/lesser.html GNU/LGPL
     
     Created by Serge Baccou
     1.0 / 20 Aug 2005
       
     Changes by Johannes Müller (http://GSiteCrawler.com)
     1.1 / 20 Aug 2005 - sorting by clicking on column headers
                       - open urls in new window/tab 
                       - some stylesheet/CSS cleanup 
     1.5a/ 31 Aug 2005 - added version number in footer
                       - removed images (don't allow tracking on other servers)
     
     Changes by Tobias Kluge (http://enarion.net)
     1.2 / 22 Aug 2005 - moved sitemap file and sitemap index file into one file gss.xsl
	 1.5 / 27 Aug 2005 - added js and css into xslt stylesheet; only gss.xsl is needed now
     
     Changes by Serge Baccou
     1.3 / 23 Aug 2005 - some XSLT cleanup
     1.4 / 24 Aug 2005 - sourceForge and LGPL links and logos
                       - sorting is working for siteindex (see gss.js) 
                       
     Changes by Matias Korhonen
     									- Deleted JS.  Changed style.
     -->

<xsl:stylesheet version="2.0" 
                xmlns:html="http://www.w3.org/TR/REC-html40"
                xmlns:sitemap="http://www.google.com/schemas/sitemap/0.84"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output method="html" version="1.0" encoding="iso-8859-1" indent="yes"/>
  
  <!-- Root template -->    
  <xsl:template match="/">
    <html>     
      <head>  
        <title>Sitemap File</title>
		<style type="text/css">
		  <![CDATA[
			<!--
			body {
				margin: 0px;
				padding: 0px;
				font-family: "Helvetica Neue", Helvetica, "Bitstream Vera Sans", "Trebuchet MS", sans-serif;
			}
			
			h1 { 
				font-weight:bold;
				font-size:1.5em;
				margin-bottom:0;
				margin-top:1px; }
			
			h2 { 
				font-weight:bold;
				font-size:1.2em;
				margin-bottom:0; 
				color:#707070;
				margin-top:1px; }
			
			#gssTitle { 	
			  line-height: 70px;
			  text-indent: 70px; }
			
			p.sml { 
				font-size:0.8em;
				margin-top:0; }
			
			.sortup {
				font-style:italic;
				white-space:pre; }
				
			.sortdown {
				font-style:italic;
				white-space:pre; }
				
			table {
				font-size: 9pt;
				border-collapse: collapse;
			}
			
			td {
				border: 1px solid #D9D9D9;
				padding: 5px 5px;
			}
			
			th {
				background: #F0F0F0;
				border: 1px solid #D9D9D9;
				padding: 5px 10px;
				color: #282828;
				font-weight: bold;
			}
			
			table.copyright {
				width:100%;
				border-top:1px solid #ddad08;
				margin-top:1em;
				text-align:center;
				padding-top:1em;
				vertical-align:top;
				font-size: 6pt;
				color: #333; }
			-->
		  ]]>
		</style>
      </head>

      <!-- Store in $fileType if we are in a sitemap or in a siteindex -->
      <xsl:variable name="fileType">
        <xsl:choose>
		  <xsl:when test="//sitemap:url">sitemap</xsl:when>
		  <xsl:otherwise>siteindex</xsl:otherwise>
        </xsl:choose>      
      </xsl:variable>            

      <!-- Body -->
      <body onLoad="initXsl('table0','{$fileType}');">  
            
        <!-- Text and table -->
        <h1 id="head1">Sitemap</h1>        
        <xsl:choose>
	      <xsl:when test="$fileType='sitemap'"><xsl:call-template name="sitemapTable"/></xsl:when>
	      <xsl:otherwise><xsl:call-template name="siteindexTable"/></xsl:otherwise>
  		</xsl:choose>
          
        <!-- Copyright notice
             &#x0020; means significant space character -->          
        <br/>
        <table class="copyright" id="table_copyright">
          <tr>
            <td>
            	<p>Modified by Matias Korhonen 2009</p>
              <p>Google Sitemaps: © 2005 <a href="http://www.google.com">Google</a> - <a href="https://www.google.com/webmasters/sitemaps/stats">My Sitemaps</a> - <a href="http://www.google.com/webmasters/sitemaps/docs/en/about.html">About</a> - <a href="http://www.google.com/webmasters/sitemaps/docs/en/faq.html">FAQ</a> - <a href="http://groups-beta.google.com/group/google-sitemaps">Discussion</a> - <a href="http://sitemaps.blogspot.com/">Blog</a></p>
              Google Sitemaps Stylesheets v1.5a: © 2005 <a href="http://www.baccoubonneville.com">Baccou Bonneville</a> - <a href="http://sourceforge.net/projects/gstoolbox">Project</a> - <a href="http://www.baccoubonneville.com/blogs/index.php/webdesign/2005/08/20/google-sitemaps-stylesheets">Blog</a><br/>
              Contributions: Johannes Müller, SOFTplus <a href="http://gsitecrawler.com">GSiteCrawler</a> - Tobias Kluge, enarion.net <a href="http://enarion.net/google/phpsitemapng">phpSitemapNG</a>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>     

  <!-- siteindexTable template -->
  <xsl:template name="siteindexTable">
    <h2>Number of sitemaps in this sitemap index: <xsl:value-of select="count(sitemap:sitemapindex/sitemap:sitemap)"></xsl:value-of></h2>          
    <table border="1" width="100%" class="data" id="table0">
      <tr class="header">
        <td>Sitemap URL</td>
        <td>Last modification date</td>
      </tr>
      <xsl:apply-templates select="sitemap:sitemapindex/sitemap:sitemap">
        <xsl:sort select="sitemap:lastmod" order="descending"/>              
      </xsl:apply-templates>  
    </table>            
  </xsl:template>  
  
  <!-- sitemapTable template -->  
  <xsl:template name="sitemapTable">
    <h2>Number of URLs in this sitemap: <xsl:value-of select="count(sitemap:urlset/sitemap:url)"></xsl:value-of></h2>
    <table border="1" width="100%" class="data" id="table0">
	  <tr class="header">
	    <td>Sitemap URL</td>
		<td>Last modification date</td>
		<td>Change freq.</td>
		<td>Priority</td>
	  </tr>
	  <xsl:apply-templates select="sitemap:urlset/sitemap:url">
	    <xsl:sort select="sitemap:priority" order="descending"/>              
	  </xsl:apply-templates>
	</table>  
  </xsl:template>    
  
  <!-- sitemap:url template -->  
  <xsl:template match="sitemap:url">
    <tr>  
      <td>
        <xsl:variable name="sitemapURL"><xsl:value-of select="sitemap:loc"/></xsl:variable>  
        <a href="{$sitemapURL}" target="_blank" ref="nofollow"><xsl:value-of select="$sitemapURL"></xsl:value-of></a>
      </td>
      <td><xsl:value-of select="sitemap:lastmod"/></td>
      <td><xsl:value-of select="sitemap:changefreq"/></td>
      <td><xsl:value-of select="sitemap:priority"/></td>
    </tr>  
  </xsl:template>
  
  <!-- sitemap:sitemap template -->
  <xsl:template match="sitemap:sitemap">
    <tr>  
      <td>        
        <xsl:variable name="sitemapURL"><xsl:value-of select="sitemap:loc"/></xsl:variable>  
        <a href="{$sitemapURL}"><xsl:value-of select="$sitemapURL"></xsl:value-of></a>
      </td>
      <td><xsl:value-of select="sitemap:lastmod"/></td>
    </tr>  
  </xsl:template>  
  
</xsl:stylesheet>
