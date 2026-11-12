import express from "express";
import OpenAI from "openai";

const app = express();

app.use(express.json({ limit: "1mb" }));

const PORT = process.env.PORT || 3000;

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

const APP_TOKEN = process.env.APP_TOKEN;

app.get("/", (req, res) => {
  res.json({
    status: "online",
    name: "ChatGPT Minecraft AI",
    version: "1.0.0"
  });
});

app.post("/chat", async (req, res) => {
  try {
    if (!APP_TOKEN || req.headers.authorization !== `Bearer ${APP_TOKEN}`) {
      return res.status(401).json({
        error: "Unauthorized"
      });
    }

    const { message, worldState } = req.body;

    if (!message) {
      return res.status(400).json({
        error: "Missing message"
      });
    }

    const response = await openai.responses.create({
      model: process.env.OPENAI_MODEL || "gpt-6-astra",
      instructions: `
Bạn là ChatGPT, một người chơi Minecraft Bedrock.
Bạn phải sinh tồn công bằng.
Không được sử dụng lệnh gian lận.
Không được tự tạo vật phẩm.
Không được biết trước tài nguyên chưa khám phá.
Bạn phải trò chuyện bằng tiếng Việt.
Bạn có thể lập kế hoạch sinh tồn.
`,
      input: `
Thông tin thế giới:
${JSON.stringify(worldState || {})}

Tin nhắn:
${message}
`
    });

    res.json({
      reply: response.output_text
    });

  } catch (error) {
    console.error(error);

    res.status(500).json({
      error: "AI processing failed"
    });
  }
});

app.listen(PORT, "0.0.0.0", () => {
  console.log("Minecraft AI server is running!");
});
