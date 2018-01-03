<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.concurrent.Immutable;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.symphony.s2.japigen.runtime.ModelServlet;
/*
import com.google.protobuf.ByteString;

import com.symphony.s2.japigen.runtime.IModelObject;
import com.symphony.s2.japigen.runtime.JapigenRuntime;
import com.symphony.s2.japigen.runtime.ModelObject;
import com.symphony.s2.japigen.runtime.ModelObjectFactory;

import org.symphonyoss.s2.common.dom.IBooleanProvider;
import org.symphonyoss.s2.common.dom.IStringProvider;
import org.symphonyoss.s2.common.dom.IIntegerProvider;
import org.symphonyoss.s2.common.dom.ILongProvider;
import org.symphonyoss.s2.common.dom.IFloatProvider;
import org.symphonyoss.s2.common.dom.IDoubleProvider;
import org.symphonyoss.s2.common.dom.IByteStringProvider;
import org.symphonyoss.s2.common.dom.json.IJsonDomNode;
import org.symphonyoss.s2.common.dom.json.IImmutableJsonDomNode;
import org.symphonyoss.s2.common.dom.json.ImmutableJsonObject;
import org.symphonyoss.s2.common.dom.json.JsonArray;
import org.symphonyoss.s2.common.dom.json.MutableJsonObject;

import org.symphonyoss.s2.common.exception.BadFormatException;
*/

<@importFieldTypes model true/>

import ${javaFacadePackage}.${model.model.camelCapitalizedName}Factory;
import ${javaFacadePackage}.${modelJavaClassName}Servlet;

<#include "Path.ftl">
@Immutable
public abstract class ${modelJavaClassName}ModelServlet extends ModelServlet// implements I${modelJavaClassName}ModelServlet
{
<@printModel/>
  @Override
  public String getUrlPath()
  {
    return "${model.bindPath}";
  }
 <#list model.operations as operation>
 
 	@Override
 	protected final void do${operation.camelCapitalizedName}(HttpServletRequest req, HttpServletResponse resp) throws ServletException
	{
	<#list operation.cookieParameters as name, parameter>
	// parameter.class = ${parameter.class}
	// parameter.name = ${parameter.name}
	// parameter.schema.class = ${parameter.schema.class}
		<@setJavaType parameter.schema/>
		<@printField/>
		
		${javaFieldClassName?right_pad(25)} _${parameter.camelName}Value = getCookieAs${javaFieldClassName}("name", ${parameter.isRequired?c});
		${javaClassName?right_pad(25)} ${parameter.camelName} = _${parameter.camelName}Value == null ? null :
			${javaConstructTypePrefix}_${parameter.camelName}Value${javaConstructTypePostfix};

		<#if requiresChecks>
		<@checkLimits "    " parameter parameter.camelName/>
		</#if>
	</#list>
	handle${operation.camelCapitalizedName}(
	<#list operation.cookieParameters as name, parameter>
		,
	</#list>
		"${operation.camelCapitalizedName}"
		);
	}
 </#list>
 <#list model.unsupportedOperations as operation>
 
 	@Override
 	protected final void do${operation}(HttpServletRequest req, HttpServletResponse resp) throws IOException
	{
		unsupportedOperation(req, resp, "${operation}");
	}
 </#list>
}
<#include "../S2-japigen-template-java-Epilogue.ftl">