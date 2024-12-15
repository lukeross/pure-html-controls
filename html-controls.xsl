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
	--lr--form--required-flag: "*"; /* How required fields are marked */
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
				content: var(--lr--form--required-flag);
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

	/* Checkboxen */
	& .lr--form--checkbox {
		/* Render each part in turn, horizontally, label flexes */
		display: flex;
		flex-direction: row;

		& > label {
			flex-grow: 1;
			flex-shrink: 1
		}
	}

	/* Select */
	& .lr--form--select {
		/* Render each part in turn, vertically */
		display: flex;
		flex-direction: column;

		/* If choice is required, mark with a star */
		&:has(select[required]) > label:after {
			color: var(--lr--secondary);
			content: var(--lr--form--required-flag);
		}

		/* If choice is required and nothing is selected, make the star red */
		&:has(select[required]:invalid) > label:after {
			color: var(--lr--error);
		}
	}

	/* Radio */
	& .lr--form--radio-group {
		/* Render each part in turn, vertically */
		display: flex;
		flex-direction: column;

		& > .lr--form--radio {
			/* Render each part in turn, horizontally, label flexes */
			display: flex;
			flex-direction: row;

			& > label {
				flex-grow: 1;
				flex-shrink: 1
			}
		}

		/* If choice is required, mark with a star */
		&.lr--form--radio-group--required .lr--form--radio-group--label::after {
			color: var(--lr--secondary);
			content: var(--lr--form--required-flag);
		}

		/* If choice is required and nothing is selected, make the star red */
		&.lr--form--radio-group--required:has(input[type=radio]:invalid) .lr--form--radio-group--label::after {
			color: var(--lr--error);
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
				<xsl:attribute name="for"><xsl:value-of select="@name" /></xsl:attribute>
				<xsl:apply-templates select="./lr:form-label/node()" />
			</label>
		</xsl:if>

		<input>
			<xsl:apply-templates select="@*" />
			<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>
			<xsl:attribute name="type"><xsl:choose>
				<xsl:when test="@type"><xsl:value-of select="@type" /></xsl:when>
				<xsl:otherwise>text</xsl:otherwise>
			</xsl:choose></xsl:attribute>
		</input>

		<div class="lr--form--error">
			<xsl:choose>
				<xsl:when test="./lr:form-error-message"><xsl:apply-templates select="./lr:form-error-message/node()" /></xsl:when>
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

<xsl:template match="lr:form-checkbox">
	<div class="lr--form--checkbox">
		<input type="checkbox">
			<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>
			<xsl:apply-templates select="@*" />
		</input>
		<label>
			<xsl:attribute name="for"><xsl:value-of select="@name" /></xsl:attribute>
			<xsl:apply-templates select="./lr:form-label/node()" />
		</label>
	</div>
</xsl:template>

<xsl:template match="lr:form-select">
	<div class="lr--form--select">
		<xsl:if test="./lr:form-label">
			<label>
				<xsl:attribute name="for"><xsl:value-of select="@name" /></xsl:attribute>
				<xsl:apply-templates select="./lr:form-label/@*" />
				<xsl:apply-templates select="./lr:form-label/node()" />
			</label>
		</xsl:if>

		<select>
			<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates select="html:option" />
		</select>
	</div>
</xsl:template>

<xsl:template match="lr:form-radio-group">
	<div>
		<xsl:attribute name="class"><xsl:choose>
			<xsl:when test="@required">lr--form--radio-group lr--form--radio-group--required</xsl:when>
			<xsl:otherwise>lr--form--radio-group</xsl:otherwise>
		</xsl:choose></xsl:attribute>

		<xsl:if test="./lr:form-label">
			<div class="lr--form--radio-group--label">
				<xsl:apply-templates select="./lr:form-label/@*" />
				<xsl:apply-templates select="./lr:form-label/node()" />
			</div>
		</xsl:if>

		<xsl:for-each select="./lr:radio">
			<div class="lr--form--radio">
				<input type="radio">
					<xsl:attribute name="id"><xsl:value-of select="generate-id(.)" />-</xsl:attribute>
					<xsl:attribute name="name"><xsl:value-of select="../@name" /></xsl:attribute>
					<xsl:if test="../@required"><xsl:attribute name="required">required</xsl:attribute></xsl:if>
					<xsl:apply-templates select="@*" />
				</input>

				<label>
					<xsl:attribute name="for"><xsl:value-of select="generate-id(.)" />-</xsl:attribute>
					<xsl:apply-templates select="./lr:form-label/@*" />
					<xsl:apply-templates select="./lr:form-label/node()" />
				</label>
			</div>
		</xsl:for-each>
	</div>
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
