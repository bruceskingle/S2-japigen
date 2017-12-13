<#include "../S2-japigen-template-java-Prologue.ftl">
import javax.annotation.concurrent.Immutable;

import org.symphonyoss.s2.common.dom.IStringProvider;
import org.symphonyoss.s2.common.dom.json.IImmutableJsonDomNode;
import org.symphonyoss.s2.common.dom.json.ImmutableJsonObject;
import org.symphonyoss.s2.common.exception.BadFormatException;

import com.symphony.s2.japigen.runtime.IModelRegistry;
import com.symphony.s2.japigen.runtime.JapigenRuntime;
import com.symphony.s2.japigen.runtime.ModelObject;
import com.symphony.s2.japigen.runtime.ModelFactory;

import ${javaFacadePackage}.${model.camelCapitalizedName}Factory;
<#list model.children as object>
<#switch object.elementType>
    <#case "Object">
    <#case "AllOf">
    <#case "OneOf">
import ${javaFacadePackage}.${object.camelCapitalizedName};
<@importNestedTypes object/>
      <#break>
  </#switch>
</#list>

<#--- if templateDebug?? --->
<#-- Print all Factory -->
/* =====================================================================================================
 * Schema ${model}
 * ===================================================================================================*/
<#list model.children as object>

<@setModelJavaType object/>
<@printModel/>
<#switch object.elementType>
  <#case "Object">
    <#list object.fields as field>
      <@setJavaType field/>
      <@printField/>
    </#list>
    <#break>
</#switch>
 </#list>
 <#--- /#if -->

<#--- #macro declareFactory object>
  private final ${(object.camelCapitalizedName + ".Factory")?right_pad(35)}  ${(object.camelName + "Factory_")?right_pad(35)} = new ${object.camelCapitalizedName}.Factory((${model.camelCapitalizedName}Factory)this);
</#macro>
<#macro registerFactory object>
    registry.register(${object.camelCapitalizedName}.TYPE_ID,
      ${object.camelName}Factory_);
</#macro>
<#macro getFactory object>

    public ${object.camelCapitalizedName}.Factory get${object.camelCapitalizedName}Factory()
    {
      return ${object.camelName}Factory_;
    }
</#macro --->

public abstract class ${model.camelCapitalizedName}ModelFactory extends ModelFactory implements I${model.camelCapitalizedName}ModelFactory
{
<@declareFactories model model/>
  @Override
  public void registerWith(IModelRegistry registry)
  {
<@registerFactories model model/>
  }
<@getFactories model model/>
}
<#include "../S2-japigen-template-java-Epilogue.ftl">