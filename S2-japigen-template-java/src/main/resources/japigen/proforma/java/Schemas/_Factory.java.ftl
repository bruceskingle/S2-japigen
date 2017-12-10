<#include "../S2-japigen-proforma-java-Prologue.ftl">
import javax.annotation.concurrent.Immutable;

import com.symphony.s2.japigen.runtime.ModelFactory;

import ${javaGenPackage}.${model.camelCapitalizedName}ModelFactory;

public class ${model.camelCapitalizedName}Factory extends ${model.camelCapitalizedName}ModelFactory implements I${model.camelCapitalizedName}Factory
{
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">