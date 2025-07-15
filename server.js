const Koa = require('koa');
const serve = require('koa-static');
const path = require('path');

const app = new Koa();
app.use(serve(path.join(__dirname, 'dist')));

const PORT = 8080;
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});