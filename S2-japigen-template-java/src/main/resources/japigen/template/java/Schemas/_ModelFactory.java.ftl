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

<#list model.children as object>
<#switch object.elementType>
    <#case "Object">
    <#case "AllOf">
import ${javaFacadePackage}.${object.camelCapitalizedName};
      <#break>
    
    <#case "OneOf">
// ${object.elementType} needs to be added
      <#break>
  </#switch>
</#list>

public abstract class ${model.camelCapitalizedName}ModelFactory extends ModelFactory implements I${model.camelCapitalizedName}ModelFactory
{
<#list model.children as object>
  <#switch object.elementType>
    <#case "Object">
    <#case "AllOf">
  private final ${object.camelCapitalizedName}.Factory  ${object.camelName}Factory_ = new ${object.camelCapitalizedName}.Factory(this);
      <#break>
    
    <#case "OneOf">
    // ${object.elementType} needs to be added
      <#break>
  </#switch>
</#list>
  @Override
  public void registerWith(IModelRegistry registry)
  {
<#list model.children as object>
  <#switch object.elementType>
    <#case "Object">
    <#case "AllOf">
    registry.register(${object.camelCapitalizedName}.TYPE_ID,
      ${object.camelName}Factory_);
      <#break>
    
    <#case "OneOf">
    // ${object.elementType} needs to be added
      <#break>
  </#switch>
</#list>
  }
<#list model.children as object>
  <#switch object.elementType>
    <#case "Object">
    <#case "AllOf">
    
    public ${object.camelCapitalizedName}.Factory get${object.camelCapitalizedName}Factory()
    {
      return ${object.camelName}Factory_;
    }
      <#break>
    
    <#case "OneOf">
    
    // ${object.elementType} needs to be added
      <#break>
  </#switch>
</#list>

}
<#include "../S2-japigen-template-java-Epilogue.ftl">