<#if model.paths??>
<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.concurrent.Immutable;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.symphony.s2.japigen.runtime.ModelServlet;
import com.symphony.s2.japigen.runtime.http.ParameterLocation;
import com.symphony.s2.japigen.runtime.http.RequestContext;

<@importFieldTypes model true/>

<#list model.paths.children as path>
import ${javaFacadePackage}.${path.camelCapitalizedName}Handler;
</#list>
import ${javaFacadePackage}.I${model.model.camelCapitalizedName};

@Immutable
public class ${modelJavaClassName}ModelServlet extends ModelServlet<I${model.model.camelCapitalizedName}>
{
  private static final long serialVersionUID = 1L;

  public ${modelJavaClassName}ModelServlet(I${model.model.camelCapitalizedName} model)
  {
    super(model);
<#list model.paths.children as path>
  // path ${path.path}
  // bindPath ${path.bindPath}
    register("${path.bindPath}", new ${path.camelCapitalizedName}Handler(model));
 <#list path.operations as operation>
      
  // operation ${operation}
  </#list>

</#list>
  }
 
  @Override
  public String getUrlPath()
  {
    return "${model.basePath}/*";
  }

<#-- 
 	@Override
 	protected final void do${operation.camelCapitalizedName}(HttpServletRequest req, HttpServletResponse resp) throws ServletException
	{
	   ${"RequestContext"?right_pad(25)} context = new RequestContext(req, resp);

	<#list operation.parameters as parameter>
	// parameter.class = ${parameter.class}
	// parameter.name = ${parameter.name}
  // parameter.location = ${parameter.location}
  // parameter.schema.class = ${parameter.schema.class}
		<@setJavaType parameter.schema/>
		<@printField/>
		${javaFieldClassName?right_pad(25)} _${parameter.camelName}Value = context.getParameterAs${javaFieldClassName}("${parameter.name}", ParameterLocation.${parameter.location}, ${parameter.isRequired?c});
		${javaClassName?right_pad(25)} ${parameter.camelName} = _${parameter.camelName}Value == null ? null :
		${" "?right_pad(25)}	     ${javaConstructTypePrefix}_${parameter.camelName}Value${javaConstructTypePostfix};

		<#if requiresChecks>
		<@checkLimits "    " parameter parameter.camelName/>
		</#if>
	</#list>
	   if(context.preConditionsAreMet())
	   {
	     handle${operation.camelCapitalizedName}(
	<#list operation.parameters as parameter>
		    ${parameter.camelName}<#sep>,
	</#list>
	
		  );
		}
	}
 </#list>

 <#list path.unsupportedOperations as operation>
 
 	@Override
 	protected final void do${operation}(HttpServletRequest req, HttpServletResponse resp) throws IOException
	{
		unsupportedOperation(req, resp, "${operation}");
	}
 </#list -->
}
<#include "../S2-japigen-template-java-Epilogue.ftl">
</#if>