<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" version="4.0" encoding="UTF-8" omit-xml-declaration="yes" indent="no" />

<xsl:param name="SqlInstance" />
<xsl:param name="DatabaseName" />
<xsl:param name="EventDate" />
<xsl:param name="HasGraph" />

<xsl:variable name="Title" select="'SQL Server Maintenance Notification'"/>

<xsl:attribute-set name="spacer25x45">
	<xsl:attribute name="style">float:left; margin-right:0px; margin-bottom:0px</xsl:attribute>
	<xsl:attribute name="alt">blue</xsl:attribute>
	<xsl:attribute name="width">45</xsl:attribute>
	<xsl:attribute name="height">25</xsl:attribute>
	<xsl:attribute name="align">absMiddle</xsl:attribute>
	<xsl:attribute name="src">cid:spacer.gif</xsl:attribute>
	<xsl:attribute name="title">spacer25x45</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="spacer50x1">
	<xsl:attribute name="style">float:left; margin-right:0px; margin-bottom:0px</xsl:attribute>
	<xsl:attribute name="alt">blue</xsl:attribute>
	<xsl:attribute name="width">1</xsl:attribute>
	<xsl:attribute name="height">50</xsl:attribute>
	<xsl:attribute name="src">cid:spacer.gif</xsl:attribute>
	<xsl:attribute name="title">spacer50x1</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="spacer1x36">
	<xsl:attribute name="style">float:left; margin-right:0px; margin-bottom:0px</xsl:attribute>
	<xsl:attribute name="alt">blue</xsl:attribute>
	<xsl:attribute name="width">36</xsl:attribute>
	<xsl:attribute name="height">1</xsl:attribute>
	<xsl:attribute name="src">cid:spacer.gif</xsl:attribute>
	<xsl:attribute name="title">spacer1x36</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="Graph">
	<xsl:attribute name="style">float:left; margin-right:0px; margin-bottom:0px</xsl:attribute>
	<xsl:attribute name="alt">blue</xsl:attribute>
	<xsl:attribute name="src">cid:graph.png</xsl:attribute>
	<xsl:attribute name="title">Graph</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="/">
	<html>
	<head>
		<title><xsl:value-of select="$Title" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="viewport" content="width=device-width,initial-scale=1 user-scalable=yes" />
		<meta name="color-scheme" content="light only" />
		<meta name="supported-color-schemes" content="light only" />
		<meta name="x-apple-disable-message-reformatting" />
		<meta name="format-detection" content="telephone=no, date=no, address=no, email=no, url=no" />
		<style>
			<xsl:call-template name="EmailStyles"/>
		</style>
	</head>
	<body>
		<table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%" id="bodyTable">
			<tr>
				<td align="center" valign="top">
					<table border="0" cellpadding="20" cellspacing="0" width="600" id="emailContainer">
						<tr>
							<td align="center" valign="top">
								<table border="0" cellpadding="20" cellspacing="0" width="100%" id="emailHeader">
									<tr>
										<td align="center" valign="top">
											<xsl:call-template name="EmailHeader"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td align="center" valign="top">
								<table border="0" cellpadding="20" cellspacing="0" width="100%" id="emailBody">
									<tr>
										<td align="center" valign="top">
											<xsl:call-template name="EmailBody"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td align="center" valign="top">
								<table border="0" cellpadding="20" cellspacing="0" width="100%" id="emailFooter">
									<tr>
										<td align="center" valign="top">
											<xsl:call-template name = "EmailFooter" />
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</body>
	</html>
</xsl:template>

<xsl:template name="EmailStyles">
	:root {
		color-scheme: light only;
		supported-color-schemes: light only;
	}

	* { font-family:Arial; font-size:12pt; }
	h1, h5, th { text-align: center; }
	table { margin: auto; border: thin ridge grey; border-collapse:collapse; font-size:12pt; table-layout:fixed;  }
	th { background: #0046c3; color: #fff; padding: 4px 8px; }
	td { text-align:left; vertical-align:top; padding: 4px 8px; color: #000; }
	/*
	tr:nth-child(even) { background: #dae5f4; }
	tr:nth-child(odd) { background: #b8d1f3; }
	*/
	#bodyTable { border:none; width:100%; max-width:1280px; }
	#emailContainer { border:none; width:100%; max-width:1276px; }
	#emailHeader { border:none; width:100%; max-width:1272px; }
	#emailBody { border:none; width:100%; max-width:1272px; }
	#emailFooter { border:none; width:100%; max-width:1272px; }

	.SummaryTable { border:none; width:100%; max-width:1268px; }
	.SummaryTable tr .Property { width:160px; }
	.SummaryTable tr .Value { width:available; }

	.DataFileTable { border:none; width:100%; max-width:1268px; }
	.DataFileTable tr .Property { width:212px; }
	.DataFileTable tr .Value { width:available; }

	.tr-even { background:#dae5f4; }
	.tr-odd { background:#b8d1f3; }
</xsl:template>

<xsl:template name="EmailHeader">
	<table class="SummaryTable">
		<tr>
			<td class="Property">SQL Instance:</td>
			<td class="Value"><xsl:value-of select="$SqlInstance" /></td>
		</tr>
		<xsl:if test="$DatabaseName != ''">
			<tr>
				<td class="Property">Database Name:</td>
				<td class="Value"><xsl:value-of select="$DatabaseName" /></td>
			</tr>
		</xsl:if>
		<tr>
			<td class="Property">Date:</td>
			<td class="Value"><xsl:value-of select="$EventDate" /></td>
		</tr>
		<tr><td colspan="2">&#32;</td></tr>
	</table>
</xsl:template>

<xsl:template name="EmailBody">
	<xsl:apply-templates select = "DataFile" />
</xsl:template>

<xsl:template name="EmailFooter">
	<xsl:call-template name = "nbsp" />
</xsl:template>

<xsl:template match = "DataFile">
	<table class="DataFileTable">
		<tr>
			<td class="Property">Logical File Name:</td>
			<td class="Value"><xsl:value-of select="./DataFileName" /></td>
		</tr>
		<tr>
			<td class="Property">Logical File Size:</td>
			<td class="Value"><xsl:value-of select="./DataFileSize" /> MB</td>
		</tr>
		<tr>
			<td class="Property">Logical File Free Space:</td>
			<td class="Value"><xsl:value-of select="./DataFileAvailablePercent" />%</td>
		</tr>
		<tr><td colspan="2">&#32;</td></tr>
		<tr>
			<td class="Property">Increase Logical file to:</td>
			<td class="Value"><xsl:value-of select="./RecommendedDataFileSize" /> MB</td>
		</tr>
		<xsl:if test="$HasGraph != 'true'">
			<tr>
				<td class="Value" colspan="2"><FONT COLOR="#ff0000"><b>Warning:</b> Not enough samples exists to provide a good size projection.</FONT></td>
			</tr>
		</xsl:if>
		<xsl:if test="./Reliability != ''">
			<tr>
				<td class="Property">Reliability:</td>
				<td class="Value"><xsl:value-of select="./Reliability" /></td>
			</tr>
		</xsl:if>
		<xsl:if test="./RecommendedAutoGrowth != ''">
			<tr><td colspan="2">&#32;</td></tr>
			<tr>
				<td class="Property">Recommended Auto Growth:</td>
				<td class="Value"><xsl:value-of select="./RecommendedAutoGrowth" /> MB</td>
			</tr>
		</xsl:if>
		<tr><td colspan="2">&#32;</td></tr>
	</table>
	<br />
	<xsl:if test="$HasGraph = 'true'">
		<xsl:element name="img" use-attribute-sets="Graph"></xsl:element>
	</xsl:if>
</xsl:template>

<xsl:template name="replace_sab">
	<!-- with string s, replace substring a by string b -->
	<!-- s, a and b are parameters determined upon calling  -->
	<xsl:param name="s" />
	<xsl:param name="a" />
	<xsl:param name="b" />
	<xsl:choose>
		<xsl:when test="contains($s,$a)">
			<xsl:value-of select="substring-before($s,$a)" />
			<xsl:copy-of select="$b" />
			<xsl:call-template name="replace_sab">
				<xsl:with-param name="s" select="substring-after($s,$a)" />
				<xsl:with-param name="a" select="$a" />
				<xsl:with-param name="b" select="$b" />
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$s" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="nbsp" >
	&#160;
<!--	@nbsp;	-->
</xsl:template>

</xsl:stylesheet>
