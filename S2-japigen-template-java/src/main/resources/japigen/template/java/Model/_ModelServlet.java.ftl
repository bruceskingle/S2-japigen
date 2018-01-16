<#if model.paths??>
<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.concurrent.Immutable;

import com.symphony.s2.japigen.runtime.ModelServlet;

import ${javaFacadePackage}.I${model.model.camelCapitalizedName};

@Immutable
public class ${modelJavaClassName}ModelServlet extends ModelServlet<I${model.model.camelCapitalizedName}>
{
  private static final long serialVersionUID = 1L;

  public ${modelJavaClassName}ModelServlet(
    I${model.model.camelCapitalizedName} model<#if model.paths.children?size != 0>,</#if>
<#list model.paths.children as path>
    I${path.camelCapitalizedName}ModelHandler ${path.camelName}Handler<#sep>,
</#list>

  )
  {
    super(model);
<#list model.paths.children as path>
    register(${path.camelName}Handler);
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