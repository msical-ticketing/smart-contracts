import { ethers } from "ethers";

import QRCode from "qrcode";

// Sample transaction data
const transactionData = {
  to: "0x742d35Cc6634C0532925a3b844Bc454e4438f44e", // Replace with the actual recipient address
  value: ethers.parseEther("0.1"), // 0.1 ETH
  gasLimit: 21000, // Gas limit
  gasPrice: ethers.parseUnits("50", "gwei"), // Gas price in Gwei
  data: "0x", // Additional data (can be empty)
};

// Create a transaction object
const transaction = {
  to: transactionData.to,
  value: transactionData.value,
  gasLimit: transactionData.gasLimit,
  gasPrice: transactionData.gasPrice,
  data: transactionData.data,
};

// Encode transaction data into a QR code
const qrCodeData = ethers.Transaction.from(transaction).unsignedSerialized;
QRCode.toFile("./transactionQRCode.png", qrCodeData, (err: any) => {
  if (err) throw err;

  console.log("QR code generated successfully!");
});
