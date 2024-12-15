<?xml version="1.0"?>

<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:lr="https://lukeross.uk/xml/html-controls"
>

<xsl:output method="html" />

<xsl:template match="html:head">
	<xsl:copy>
		<xsl:apply-templates select="@*" />

		<style type="text/css">
<![CDATA[
:root {
	--lr--error: red;
	--lr--secondary: grey;
}

.lr--button {
	border-radius: 0.5em;
	padding: 0.5em 1em;
}

.lr--text-input {
	display: flex;
	flex-direction: column;

	& > label {
		margin-bottom: 0.5em;
		&:has(+ input[required])::after {
			content: "*";
			color: var(--lr--secondary);
			margin-left: 0.5em;
		}

		&:has(+ input[required]:placeholder-shown)::after {
			color: var(--lr--error);
		}
	}
	

	& > input[type=text] {
		border-radius: 0.5em;
		padding: 0.5em 1em;
		width: 100%;

		&:invalid:not(:placeholder-shown) {
			border-color: var(--lr--error);
			& + .lr--form--error { display: inherit; }
		}
	}
}

form.lr--form {
	&:invalid {
		& > input[type=submit] {
			border-color: var(--lr--error);
			pointer-events: none;
			cursor: not-allowed;
		}
	}

	& > * { margin: 1em 0; }

	& .lr--form--error {
		margin-top: 0.5em;
		color: var(--lr--error);
		display: none;
	}
}
]]>
		</style>

		<xsl:apply-templates />
	</xsl:copy>
</xsl:template>

<xsl:template match="lr:form">
	<form class="lr--form">
		<xsl:apply-templates select="@*" />
		<xsl:apply-templates />
	</form>
</xsl:template>

<xsl:template match="lr:form-text">
	<div class="lr--text-input">
		<xsl:if test="./lr:label">
			<label>
				<xsl:attribute name="for"><xsl:value-of select="generate-id(.)" /></xsl:attribute>
				<xsl:apply-templates select="./lr:label" />
			</label>
		</xsl:if>

		<input
			type="text"
		>
			<xsl:attribute name="id"><xsl:value-of select="generate-id(.)" /></xsl:attribute>
			<xsl:if test="@required"><xsl:attribute name="required">required</xsl:attribute></xsl:if>
			<xsl:if test="@pattern"><xsl:attribute name="pattern"><xsl:value-of select="@pattern" /></xsl:attribute></xsl:if>
			<xsl:if test="@placeholder"><xsl:attribute name="placeholder"><xsl:value-of select="@placeholder" /></xsl:attribute></xsl:if>
		</input>

		<div class="lr--form--error">
			<xsl:choose>
				<xsl:when test="./lr:error-message"><xsl:apply-templates select="./lr:error-message" /></xsl:when>
				<xsl:otherwise>Value is invalid</xsl:otherwise>
			</xsl:choose>
		</div>
	</div>
</xsl:template>

<xsl:template match="lr:form-submit">
	<input type="submit" class="lr--button">
		<xsl:apply-templates select="@*" />
	</input>
</xsl:template>

<xsl:template match="html:*">
	<xsl:copy>
		<xsl:apply-templates select="@*" />
		<xsl:apply-templates />
	</xsl:copy>
</xsl:template>

<xsl:template match="@*|node()">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

</xsl:stylesheet> 
