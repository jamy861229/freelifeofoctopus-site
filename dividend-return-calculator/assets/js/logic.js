const MONTHLY_INCOME_TARGET = 10000;
const SUPPLEMENTAL_PREMIUM_RATE = 0.0211;

function calcGrossDividend(twdAmount, yieldRate) {
    if (twdAmount <= 0 || yieldRate < 0) return 0;
    return twdAmount * yieldRate;
}

function calcCostAmount(twdAmount, feeRate) {
    if (twdAmount <= 0 || feeRate < 0) return 0;
    return twdAmount * feeRate;
}

function calcSupplementalPremiumAmount(grossDividend, enabled) {
    if (!enabled || grossDividend <= 0) return 0;
    return grossDividend * SUPPLEMENTAL_PREMIUM_RATE;
}

function calcNetAnnualIncome(grossDividend, costAmount, supplementalPremiumAmount) {
    return grossDividend - costAmount - supplementalPremiumAmount;
}

function calcActualReturnRate(netAnnualIncome, twdAmount) {
    if (twdAmount <= 0) return 0;
    return netAnnualIncome / twdAmount;
}

function calcMonthlyCashflow(netAnnualIncome) {
    return netAnnualIncome / 12;
}

function calcEstimatedShares(twdAmount, stockPrice) {
    if (twdAmount <= 0 || stockPrice <= 0) return null;
    return twdAmount / stockPrice;
}

function judgeResult(actualReturnRate) {
    if (actualReturnRate < 0.02) return "red";
    if (actualReturnRate < 0.04) return "yellow";
    return "green";
}

function hasMeaningfulMonthlyIncome(monthlyCashflow) {
    return monthlyCashflow >= MONTHLY_INCOME_TARGET;
}
