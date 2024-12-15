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
	--lr--error: red; /* Used for error states */
	--lr--secondary: grey; /* Used for UI hints */
}

div.lr--accordion {
	/* Expansion below the heading */
	display: flex;
	flex-direction: column ;

	/* Hide expansion by default */
	& .lr--accordion--closed { display: inline-block; }
	& .lr--accordion--open { display: none; }

	& > label {
		/* Let user know they can click this */
		cursor: grab;

		/* Ensure checkbox is hidden */
		& > input[type=checkbox] { visibility: hidden; width: 0; height: 0; position: fixed; left: -100px; }
	}

	/* Changes when expanded */
	&:has(> label > input[type=checkbox]:checked) {
		/* Set up the bit(s) that change on expansion */
		& .lr--accordion--closed { display: none; }
		& .lr--accordion--open { display: inline-block; }
	}
}

form.lr--form {
	/* Error messages are hidden until needed */
	& .lr--form--error {
		color: var(--lr--error);
		display: none;
	}

	/* Submit buttons are unclickable until valid */
	&:invalid > input[type=submit].lr--form--submit {
		border-color: var(--lr--error);
		pointer-events: none;
		cursor: not-allowed;
	}

	/* Text fields */
	& .lr--text-input {
		/* Render each part in turn, vertically */
		display: flex;
		flex-direction: column;

		& > label {
			/* If field is required mark it with a secondary star */
			&:has(+ input[required])::after {
				content: "*";
				color: var(--lr--secondary);
				margin-left: 0.5em;
			}

			/* When required text field is not yet set mark it with an error star */
			&:has(+ input[required]:placeholder-shown)::after {
				color: var(--lr--error);
			}

			/* Required non-text fields show no placeholder so base it on validity */
			&:has(+ input[required]:not([type=text]):invalid)::after {
				color: red;
			}
		}
	

		/* When input is invalid highlight the border colour and show error message */
		& > input[type=text] {
			&:invalid:not(:placeholder-shown) {
				border-color: var(--lr--error);
				& + .lr--form--error { display: inherit; }
			}
		}
	}
}

.lr--tooltip {
	/* Set up a context for the tooltip */
    position: relative;

	/* Tooltips are hidden by default */
    & > .lr--tooltip--content {
        display: none;
        z-index: 10;
    }

	/* Render on hover */
    &:hover > .lr--tooltip--content {
        position: absolute;
        display: block;

		/* Select the correct position */
        &.lr--tooltip--over { bottom: 100% }
        &.lr--tooltip--under { top: 100%; }
    }

	/* Render on active, for touch screens etc */
    &:active > .lr--tooltip--content.lr--tooltip--under {
        position: absolute;
        display: block;

		/* Select the correct position */
        &.lr--tooltip--over { bottom: 100% }
        &.lr--tooltip--under { top: 100%; }
    }
}
]]>
		</style>

		<xsl:apply-templates />
	</xsl:copy>
</xsl:template>

<xsl:template match="lr:form">
	<form>
		<xsl:apply-templates select="@*" />
		<xsl:attribute name="class"><xsl:value-of select="concat('lr--form ', @class)" /></xsl:attribute>
		<xsl:apply-templates />
	</form>
</xsl:template>

<xsl:template match="lr:form-text">
	<div class="lr--text-input">
		<xsl:if test="./lr:form-label">
			<label>
				<xsl:attribute name="for"><xsl:value-of select="generate-id(.)" /></xsl:attribute>
				<xsl:apply-templates select="./lr:form-label" />
			</label>
		</xsl:if>

		<input>
			<xsl:attribute name="id"><xsl:value-of select="generate-id(.)" /></xsl:attribute>
			<xsl:attribute name="type"><xsl:choose>
				<xsl:when test="@type"><xsl:value-of select="@type" /></xsl:when>
				<xsl:otherwise>text</xsl:otherwise>
			</xsl:choose></xsl:attribute>
			<xsl:apply-templates select="@*" />
		</input>

		<div class="lr--form--error">
			<xsl:choose>
				<xsl:when test="./lr:form-error-message"><xsl:apply-templates select="./lr:form-error-message" /></xsl:when>
				<xsl:otherwise>Value is invalid</xsl:otherwise>
			</xsl:choose>
		</div>
	</div>
</xsl:template>

<xsl:template match="lr:form-submit">
	<input type="submit">
		<xsl:apply-templates select="@*" />
		<xsl:attribute name="class"><xsl:value-of select="concat('lr--form--submit ', @class)" /></xsl:attribute>
	</input>
</xsl:template>

<xsl:template match="lr:accordion">
	<div>
		<xsl:apply-templates select="@*" />
		<xsl:attribute name="class"><xsl:value-of select="concat('lr--accordion ', @class)" /></xsl:attribute>
		<xsl:apply-templates />
	</div>
</xsl:template>

<xsl:template match="lr:accordion-label">
	<label>
		<xsl:apply-templates select="@*" />
        <input type="checkbox" />
		<xsl:apply-templates />
	</label>
</xsl:template>

<xsl:template match="lr:accordion-open">
	<div>
		<xsl:apply-templates select="@*" />
		<xsl:attribute name="class"><xsl:value-of select="concat('lr--accordion--open ', @class)" /></xsl:attribute>
		<xsl:apply-templates />
	</div>
</xsl:template>

<xsl:template match="lr:accordion-closed">
	<div>
		<xsl:apply-templates select="@*" />
		<xsl:attribute name="class"><xsl:value-of select="concat('lr--accordion--closed ', @class)" /></xsl:attribute>
		<xsl:apply-templates />
	</div>
</xsl:template>

<xsl:template match="lr:tooltip-wrapper">
	<div>
		<xsl:apply-templates select="@*" />
		<xsl:attribute name="class"><xsl:value-of select="concat('lr--tooltip ', @class)" /></xsl:attribute>
		<xsl:apply-templates />
	</div>
</xsl:template>

<xsl:template match="lr:tooltip">
	<div>
		<xsl:apply-templates select="@*" />
		<xsl:attribute name="class"><xsl:choose>
			<xsl:when test="@position = 'over'"><xsl:value-of select="concat('lr--tooltip--content lr--tooltip--over ', @class)" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="concat('lr--tooltip--content lr--tooltip--under ', @class)" /></xsl:otherwise>
		</xsl:choose></xsl:attribute>
		<xsl:apply-templates />
	</div>
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
