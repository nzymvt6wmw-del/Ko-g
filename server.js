import express from "express";
import { GoogleGenAI } from "@google/genai";

const app = express();

app.use(express.json());

const PORT = process.env.PORT || 3000;

const apiKey = process.env.GEMINI_API_KEY;

if (!apiKey) {
  console.error("THIEU GEMINI_API_KEY!");
  process.exit(1);
}

const ai = new GoogleGenAI({
  apiKey: apiKey
});

app.get("/", (req, res) => {
  res.send("Minecraft Gemini AI Server is running!");
});

app.get("/health", (req, res) => {
  res.json({
    status: "online",
    ai: "Gemini"
  });
});

app.post("/chat", async (req, res) => {
  try {
    const message = req.body.message;

    if (!message) {
      return res.status(400).json({
        error: "Bạn chưa nhập tin nhắn!"
      });
    }

    const response = await ai.models.generateContent({
      model: "gemini-2.5-flash",
      contents: message,
      config: {
        systemInstruction:
          "Bạn là một AI trợ lý Minecraft. Bạn nói tiếng Việt, thông minh, thân thiện và có khả năng lập kế hoạch sinh tồn trong Minecraft. Hãy trả lời rõ ràng và hữu ích."
      }
    });

    res.json({
      success: true,
      reply: response.text
    });

  } catch (error) {
    console.error("Gemini error:", error.message);

    res.status(500).json({
      success: false,
      error: "Không thể kết nối Gemini. Hãy kiểm tra API key hoặc hạn mức."
    });
  }
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
