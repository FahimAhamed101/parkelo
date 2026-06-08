function roundMoney(value) {
  return Math.round((Number(value) || 0) * 100) / 100;
}

function calculateBookingPricing(parking, durationHours, insuranceIncluded = false) {
  const hourlyRate = parking.rate.hourly;
  const durationSubtotal = roundMoney(hourlyRate * durationHours);
  const insuranceFee =
    insuranceIncluded && parking.insurance && parking.insurance.available
      ? roundMoney(parking.insurance.fee)
      : 0;
  const taxRate = parking.rate.taxRate;
  const taxAmount = roundMoney(durationSubtotal * taxRate);
  const serviceFee = roundMoney(parking.rate.serviceFee);
  const total = roundMoney(durationSubtotal + insuranceFee + taxAmount + serviceFee);

  return {
    hourlyRate,
    durationSubtotal,
    extensionSubtotal: 0,
    insuranceFee,
    taxRate,
    taxAmount,
    serviceFee,
    total,
    paidTotal: total,
    currency: parking.rate.currency,
    currencySymbol: parking.rate.currencySymbol,
  };
}

function calculateExtensionPricing(parking, additionalHours) {
  const subtotal = roundMoney(parking.rate.hourly * additionalHours);
  const taxAmount = roundMoney(subtotal * parking.rate.taxRate);
  const serviceFee = roundMoney(parking.rate.serviceFee);
  const total = roundMoney(subtotal + taxAmount + serviceFee);

  return {
    hours: additionalHours,
    subtotal,
    taxAmount,
    serviceFee,
    total,
    currency: parking.rate.currency,
    currencySymbol: parking.rate.currencySymbol,
  };
}

function formatMoney(amount, currencySymbol = "RD$") {
  return `${currencySymbol}${roundMoney(amount)}`;
}

module.exports = {
  calculateBookingPricing,
  calculateExtensionPricing,
  formatMoney,
  roundMoney,
};
