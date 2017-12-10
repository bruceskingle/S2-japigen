<#include "../S2-japigen-proforma-java-Prologue.ftl">
import javax.annotation.concurrent.Immutable;

import com.symphony.s2.japigen.runtime.ModelSchemas;

import ${javaGenPackage}.${model.camelCapitalizedName}ModelSchemas;

public class ${model.camelCapitalizedName}Schemas extends ${model.camelCapitalizedName}ModelSchemas implements I${model.camelCapitalizedName}Schemas
{
  
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">